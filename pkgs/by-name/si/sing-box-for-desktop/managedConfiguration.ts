import { app } from "electron";
import {
  mkdirSync,
  readFileSync,
  readdirSync,
  renameSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { isAbsolute, join } from "node:path";

import {
  preferenceSnapshot,
  removePreference,
  setPreference,
  settingsDatabase,
} from "./database";
import { setOpenAtLogin } from "./loginItem";

interface ManagedProfile {
  id: string;
  name: string;
  configurationPath: string;
}

interface ManagedConfiguration {
  version: 1;
  openAtLogin?: boolean;
  preferences: Record<string, unknown>;
  removePreferences: string[];
  terminal: Record<string, unknown>;
  profiles?: ManagedProfile[];
  selectedProfileId?: string;
}

const MANAGED_CONFIGURATION_ENVIRONMENT = "SING_BOX_MANAGED_CONFIGURATION";
const PROFILE_ID_PATTERN = /^[0-9a-f]{64}$/;
const TERMINAL_DEFAULTS = {
  symbolBarAlwaysShow: false,
  lightThemeName: "Alabaster",
  darkThemeName: "Afterglow",
  lightThemeCustom: "",
  darkThemeCustom: "",
  fontFamily: "",
  fontSize: 13,
};

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function parseManagedProfile(value: unknown): ManagedProfile {
  if (!isRecord(value)) {
    throw new Error("managed profile must be an object");
  }
  if (typeof value.id !== "string" || !PROFILE_ID_PATTERN.test(value.id)) {
    throw new Error("managed profile has an invalid identifier");
  }
  if (typeof value.name !== "string" || value.name === "") {
    throw new Error("managed profile has an invalid name");
  }
  if (typeof value.configurationPath !== "string" || !isAbsolute(value.configurationPath)) {
    throw new Error(`managed profile ${value.name} has an invalid configuration path`);
  }
  return {
    id: value.id,
    name: value.name,
    configurationPath: value.configurationPath,
  };
}

function loadManagedConfiguration(): ManagedConfiguration | null {
  const path = process.env[MANAGED_CONFIGURATION_ENVIRONMENT];
  if (!path) {
    return null;
  }
  const value: unknown = JSON.parse(readFileSync(path, "utf8"));
  if (!isRecord(value) || value.version !== 1) {
    throw new Error("unsupported managed configuration");
  }
  if (!isRecord(value.preferences) || !isRecord(value.terminal)) {
    throw new Error("managed preferences must be objects");
  }
  const removePreferences = value.removePreferences ?? [];
  if (
    !Array.isArray(removePreferences) ||
    !removePreferences.every(
      (name) => typeof name === "string" && name !== "" && name.length <= 128,
    ) ||
    new Set(removePreferences).size !== removePreferences.length
  ) {
    throw new Error("managed preference removals must be unique preference names");
  }
  if (value.openAtLogin !== undefined && typeof value.openAtLogin !== "boolean") {
    throw new Error("managed start-at-login setting must be boolean");
  }
  let profiles: ManagedProfile[] | undefined;
  if (value.profiles !== undefined) {
    if (!Array.isArray(value.profiles)) {
      throw new Error("managed profiles must be an array");
    }
    profiles = value.profiles.map(parseManagedProfile);
    if (new Set(profiles.map((profile) => profile.id)).size !== profiles.length) {
      throw new Error("managed profile identifiers must be unique");
    }
  }
  if (
    value.selectedProfileId !== undefined &&
    (typeof value.selectedProfileId !== "string" ||
      !PROFILE_ID_PATTERN.test(value.selectedProfileId))
  ) {
    throw new Error("managed default profile has an invalid identifier");
  }
  if (
    value.selectedProfileId !== undefined &&
    !profiles?.some((profile) => profile.id === value.selectedProfileId)
  ) {
    throw new Error("managed default profile is not present in the profile list");
  }
  return {
    version: 1,
    openAtLogin: value.openAtLogin,
    preferences: value.preferences,
    removePreferences,
    terminal: value.terminal,
    profiles,
    selectedProfileId: value.selectedProfileId,
  };
}

function applyManagedPreferences(configuration: ManagedConfiguration): void {
  for (const name of configuration.removePreferences) {
    removePreference(name);
  }
  for (const [name, value] of Object.entries(configuration.preferences)) {
    setPreference(name, value);
  }
  if (Object.keys(configuration.terminal).length > 0) {
    const stored = preferenceSnapshot(["terminal-config"])["terminal-config"];
    setPreference("terminal-config", {
      ...TERMINAL_DEFAULTS,
      ...(isRecord(stored) ? stored : {}),
      ...configuration.terminal,
    });
  }
  if (configuration.openAtLogin !== undefined) {
    setOpenAtLogin(configuration.openAtLogin);
  }
}

function profilesDirectory(): string {
  return join(app.getPath("userData"), "profiles");
}

function writeProfile(profile: ManagedProfile): void {
  const directory = profilesDirectory();
  mkdirSync(directory, { recursive: true });
  const path = join(directory, `${profile.id}.json`);
  const temporaryPath = `${path}.${crypto.randomUUID()}.tmp`;
  const configuration: unknown = JSON.parse(readFileSync(profile.configurationPath, "utf8"));
  if (!isRecord(configuration)) {
    throw new Error(`managed profile ${profile.name} configuration must be a JSON object`);
  }
  try {
    writeFileSync(temporaryPath, `${JSON.stringify(configuration, null, 2)}\n`, {
      mode: 0o600,
    });
    renameSync(temporaryPath, path);
  } finally {
    rmSync(temporaryPath, { force: true });
  }
}

function removeUnmanagedProfileFiles(profileIds: Set<string>): void {
  const directory = profilesDirectory();
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    if (!entry.isFile() || !entry.name.endsWith(".json")) {
      continue;
    }
    const id = entry.name.slice(0, -".json".length);
    if (!profileIds.has(id)) {
      rmSync(join(directory, entry.name), { force: true });
    }
  }
}

function applyManagedProfiles(configuration: ManagedConfiguration): void {
  if (configuration.profiles === undefined) {
    return;
  }
  const profiles = configuration.profiles;
  const profileIds = new Set(profiles.map((profile) => profile.id));
  mkdirSync(profilesDirectory(), { recursive: true });
  const storedSelectedProfile = preferenceSnapshot(["selected_profile_id"])[
    "selected_profile_id"
  ];
  const selectedProfileId =
    configuration.selectedProfileId ??
    (typeof storedSelectedProfile === "string" && profileIds.has(storedSelectedProfile)
      ? storedSelectedProfile
      : (profiles[0]?.id ?? null));

  for (const profile of profiles) {
    writeProfile(profile);
  }

  const store = settingsDatabase();
  store.transaction(() => {
    store.prepare("DELETE FROM profiles").run();
    const insert = store.prepare(
      `INSERT INTO profiles (id, name, type, remote_url, auto_update,
       auto_update_interval_minutes, last_updated, item_order)
       VALUES (?, ?, 'local', NULL, 0, 60, NULL, ?)`,
    );
    for (const [index, profile] of profiles.entries()) {
      insert.run(profile.id, profile.name, index);
    }
    if (selectedProfileId === null) {
      removePreference("selected_profile_id");
    } else {
      setPreference("selected_profile_id", selectedProfileId);
    }
  })();
  removeUnmanagedProfileFiles(profileIds);
}

export function applyManagedConfiguration(): void {
  const configuration = loadManagedConfiguration();
  if (configuration === null) {
    return;
  }
  applyManagedPreferences(configuration);
  applyManagedProfiles(configuration);
}
