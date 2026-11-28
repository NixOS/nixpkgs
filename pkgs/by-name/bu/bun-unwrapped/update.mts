#!/usr/bin/env nix-shell
/*
#!nix-shell -i node -p cacert coreutils git nix nix-prefetch-git nodejs
*/
import { execFileSync, spawnSync } from "node:child_process";
import {
  chmodSync,
  mkdirSync,
  mkdtempSync,
  readdirSync,
  readFileSync,
  renameSync,
  rmSync,
  statSync,
  writeFileSync,
} from "node:fs";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";
import process from "node:process";
import { parseArgs } from "node:util";

const packageDir = import.meta.dirname;
const root = resolve(packageDir, "../../../..");
const sourcesFile = join(packageDir, "sources.json");
const bunRepo = "https://github.com/oven-sh/bun";
const fakeHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

const bootstrapNames = {
  "aarch64-darwin": "bun-darwin-aarch64",
  "aarch64-linux": "bun-linux-aarch64",
  "aarch64-linux-musl": "bun-linux-aarch64-musl",
  "x86_64-linux": "bun-linux-x64-baseline",
  "x86_64-linux-musl": "bun-linux-x64-musl-baseline",
} as const;

// Linux installs include both libc variants, so one hash covers glibc and musl.
const nodeModulesTargets = {
  "aarch64-darwin": ["darwin", "arm64"],
  "aarch64-linux": ["linux", "arm64"],
  "x86_64-linux": ["linux", "x64"],
} as const;
// Mirrors package.nix and upstream's emitPackageInstall() calls.
const nodeModulesDirs = [
  ".",
  "packages/bun-error",
  "src/node-fallbacks",
] as const;

interface Archive {
  name: string;
  url: string;
}

interface BootstrapPin {
  name: string;
  hash: string;
}

interface WebKitPin {
  rev: string;
  version: string;
  hash: string;
  sparseCheckout: string[];
}

interface Sources {
  version: string;
  revision: string;
  sourceHash: string;
  cargoHash: string;
  bootstrapAssets: Record<string, BootstrapPin>;
  nodeModulesHashes: Record<string, string>;
  downloads: (Archive & { hash: string })[];
  webkit: WebKitPin;
}

function output(
  command: string,
  args: string[],
  cwd = root,
  env = process.env,
): string {
  return execFileSync(command, args, {
    cwd,
    env,
    encoding: "utf8",
    stdio: ["ignore", "pipe", "inherit"],
    maxBuffer: 16 * 1024 * 1024,
  }).trim();
}

function nixString(value: string): string {
  return JSON.stringify(value).replaceAll("${", "\\${");
}

function capture(pattern: RegExp, text: string, source: string): string {
  const value = pattern.exec(text)?.[1];
  if (value === undefined)
    throw new Error(`Cannot parse ${source}: ${pattern}`);
  return value;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function prefetch(
  url: string,
  unpack = false,
): { hash: string; storePath: string } {
  const args = ["store", "prefetch-file", "--json"];
  if (unpack) args.push("--unpack");
  const result: unknown = JSON.parse(output("nix", [...args, url]));
  if (
    !isRecord(result) ||
    typeof result.hash !== "string" ||
    typeof result.storePath !== "string"
  ) {
    throw new Error(`Invalid prefetch result for ${url}`);
  }
  return { hash: result.hash, storePath: result.storePath };
}

function stableReleases(): Map<string, string> {
  const tags = output("git", [
    "ls-remote",
    "--tags",
    "--refs",
    bunRepo,
    "refs/tags/bun-v*",
  ]);
  const releases = new Map<string, string>();
  for (const [, revision, version] of tags.matchAll(
    /^([a-f0-9]+)\trefs\/tags\/bun-v(\d+\.\d+\.\d+)$/gm,
  )) {
    if (revision && version) releases.set(version, revision);
  }
  return releases;
}

function resolveConstant(
  text: string,
  expression: string,
  source: string,
): string {
  const value = expression.trim();
  if (value.startsWith('"')) {
    const literal: unknown = JSON.parse(value);
    if (typeof literal === "string") return literal;
  }
  if (!/^\w+$/.test(value))
    throw new Error(`Invalid constant in ${source}: ${value}`);
  return capture(
    new RegExp(`\\bconst\\s+${value}(?:\\s*:[^=]+)?\\s*=\\s*"([^"]+)"`),
    text,
    source,
  );
}

function sourceArchives(source: string): Archive[] {
  const dir = join(source, "scripts/build/deps");
  const archives = new Map<string, Archive>();
  for (const file of readdirSync(dir)) {
    if (!file.endsWith(".ts")) continue;
    const path = join(dir, file);
    const text = readFileSync(path, "utf8");
    if (
      !text.includes('kind: "github-archive"') ||
      /enabled:\s*cfg\s*=>\s*cfg\.windows\b/.test(text)
    )
      continue;

    const symbol = capture(/export const (\w+): Dependency/, text, path);
    const name = capture(/name:\s*"([^"]+)"/, text, path);
    const repo = capture(/repo:\s*"([^"]+)"/, text, path);
    const rev = resolveConstant(
      text,
      capture(/commit:\s*([^,\n]+)/, text, path),
      path,
    );
    archives.set(symbol, {
      name,
      url: `https://github.com/${repo}/archive/${rev}.tar.gz`,
    });
  }

  const index = join(dir, "index.ts");
  const deps = capture(
    /export const allDeps:[^=]+?=\s*\[(.*?)\];/s,
    readFileSync(index, "utf8"),
    index,
  );
  const downloads: Archive[] = [];
  for (const [, symbol] of deps
    .replace(/\/\/[^\n]*/g, "")
    .matchAll(/^\s*(\w+)\s*,/gm)) {
    const archive = symbol && archives.get(symbol);
    if (archive) downloads.push(archive);
  }

  const headers = join(dir, "nodejs-headers.ts");
  const text = readFileSync(headers, "utf8");
  const nodeVersionExpr = capture(
    /export const NODEJS_VERSION = ([^;]+);/,
    text,
    headers,
  ).trim();
  const ciPins = join(source, "scripts/build/ci-images/spec.ts");
  const nodeVersion =
    nodeVersionExpr === "pins.nodejs.version"
      ? capture(
          /nodejs:\s*\{\s*version:\s*"([^"]+)"/,
          readFileSync(ciPins, "utf8"),
          ciPins,
        )
      : resolveConstant(text, nodeVersionExpr, headers);
  downloads.push({
    name: "nodejs-headers",
    url: `https://nodejs.org/dist/v${nodeVersion}/node-v${nodeVersion}-headers.tar.gz`,
  });
  return downloads;
}

function pinWebKit(
  source: string,
  current: WebKitPin,
  force: boolean,
): WebKitPin {
  const path = join(source, "scripts/build/deps/webkit.ts");
  const rev = capture(
    /export const WEBKIT_VERSION = "([^"]+)";/,
    readFileSync(path, "utf8"),
    path,
  );
  if (rev === current.rev && current.version && !force) return current;

  const result: unknown = JSON.parse(
    output("nix-prefetch-git", [
      "--quiet",
      "--url",
      "https://github.com/oven-sh/WebKit.git",
      "--rev",
      rev,
      "--name",
      "bun-webkit-source",
      "--sparse-checkout",
      current.sparseCheckout.join("\n"),
    ]),
  );
  if (!isRecord(result) || typeof result.date !== "string") {
    throw new Error("nix-prefetch-git returned no WebKit commit date");
  }
  const hash = result.hash ?? result.sha256;
  if (typeof hash !== "string")
    throw new Error("nix-prefetch-git returned no WebKit hash");
  const day = capture(
    /^(\d{4}-\d{2}-\d{2})T/,
    result.date,
    "WebKit commit date",
  );
  return {
    rev,
    version: `0-unstable-${day}`,
    hash,
    sparseCheckout: current.sparseCheckout,
  };
}

function cargoHash(version: string, source: string): string {
  const expression = `
let pkgs = import ./. {}; in
pkgs.rustPlatform.fetchCargoVendor {
  pname = "bun-cargo-deps";
  version = ${nixString(version)};
  src = builtins.storePath ${nixString(source)};
  hash = ${nixString(fakeHash)};
}`;
  const result = spawnSync(
    "nix",
    ["build", "--impure", "--no-link", "--expr", expression],
    {
      cwd: root,
      encoding: "utf8",
      maxBuffer: 16 * 1024 * 1024,
    },
  );
  if (result.error) throw result.error;
  const hash = /got:\s+(sha256-[A-Za-z0-9+/=]+)/.exec(result.stderr)?.[1];
  if (!hash)
    throw new Error(
      `Cannot determine Cargo vendor hash:\n${result.stdout}${result.stderr}`,
    );
  return hash;
}

function bootstrapUrl(version: string, name: string): string {
  return `${bunRepo}/releases/download/bun-v${version}/${name}.zip`;
}

function bootstrapPath(version: string, asset: BootstrapPin): string {
  const expression = `
let pkgs = import ./. {}; in
pkgs.stdenvNoCC.mkDerivation {
  pname = "bun-update-bootstrap";
  version = ${nixString(version)};
  src = pkgs.fetchurl {
    url = ${nixString(bootstrapUrl(version, asset.name))};
    hash = ${nixString(asset.hash)};
  };
  sourceRoot = ${nixString(asset.name)};
  nativeBuildInputs = [ pkgs.unzip ]
    ++ pkgs.lib.optionals pkgs.stdenv.buildPlatform.isLinux [ pkgs.autoPatchelfHook ];
  buildInputs = pkgs.lib.optionals pkgs.stdenv.buildPlatform.isLinux [
    pkgs.openssl pkgs.stdenv.cc.cc.lib
  ];
  postFixup = pkgs.lib.optionalString pkgs.stdenv.buildPlatform.isDarwin ''
    \${pkgs.lib.getExe' pkgs.cctools "install_name_tool"} "$out/bin/bun" \\
      -change /usr/lib/libicucore.A.dylib '\${pkgs.lib.getLib pkgs.darwin.ICU}/lib/libicucore.A.dylib'
    \${pkgs.lib.getExe pkgs.rcodesign} sign --code-signature-flags linker-signed "$out/bin/bun"
  '';
  installPhase = ''
    runHook preInstall
    install -Dm755 bun "$out/bin/bun"
    runHook postInstall
  '';
  meta.sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
}`;
  return output("nix", [
    "build",
    "--impure",
    "--no-link",
    "--print-out-paths",
    "--expr",
    expression,
  ]);
}

function nodeModulesHashes(
  source: string,
  bootstrap: string,
): Record<string, string> {
  const tmp = mkdtempSync(join(tmpdir(), "bun-update-"));
  const hashes: Record<string, string> = {};
  try {
    for (const [platform, [os, cpu]] of Object.entries(nodeModulesTargets)) {
      const checkout = join(tmp, platform);
      output("cp", ["-R", "--reflink=auto", source, checkout]);
      output("chmod", ["-R", "u+w", checkout]);
      const home = join(tmp, `home-${platform}`);
      const cache = join(tmp, `cache-${platform}`);
      mkdirSync(home);
      mkdirSync(cache);
      const env = { ...process.env, HOME: home, BUN_INSTALL_CACHE_DIR: cache };
      console.log(`Installing Node modules for ${platform}`);
      for (const dir of nodeModulesDirs) {
        output(
          join(bootstrap, "bin/bun"),
          ["install", "--frozen-lockfile", `--os=${os}`, `--cpu=${cpu}`],
          join(checkout, dir),
          env,
        );
      }
      const result = join(tmp, `node-modules-${platform}`);
      mkdirSync(result);
      output(
        "cp",
        [
          "-R",
          "--parents",
          ...nodeModulesDirs.map((dir) => join(dir, "node_modules")),
          result,
        ],
        checkout,
      );
      hashes[platform] = output("nix", ["hash", "path", result]);
    }
    return hashes;
  } finally {
    rmSync(tmp, { recursive: true, force: true });
  }
}

function saveSources(sources: Sources): void {
  const mode = statSync(sourcesFile).mode & 0o777;
  const tmp = mkdtempSync(join(packageDir, ".sources-"));
  try {
    const file = join(tmp, "sources.json");
    writeFileSync(file, `${JSON.stringify(sources, null, 2)}\n`);
    chmodSync(file, mode);
    renameSync(file, sourcesFile);
  } finally {
    rmSync(tmp, { recursive: true, force: true });
  }
}

function main(): void {
  const { values } = parseArgs({
    options: {
      version: { type: "string" },
      force: { type: "boolean", default: false },
      help: { type: "boolean", short: "h", default: false },
    },
  });
  if (values.help) {
    console.log(
      "Usage: update.mts [--version VERSION] [--force]\n\n--force  Regenerate hashes when the version is unchanged",
    );
    return;
  }
  const current: Sources = JSON.parse(readFileSync(sourcesFile, "utf8"));
  const releases = stableReleases();
  const version =
    values.version ??
    [...releases.keys()]
      .sort((a, b) => a.localeCompare(b, "en", { numeric: true }))
      .at(-1);
  if (!version) throw new Error("No stable Bun releases found");
  const revision = releases.get(version);
  if (!revision) throw new Error(`Bun release bun-v${version} does not exist`);
  if (version === current.version && !values.force) {
    console.log(`Bun ${version} is already up to date`);
    return;
  }

  console.log(`Updating Bun ${current.version} -> ${version}`);
  const { hash: sourceHash, storePath: source } = prefetch(
    `${bunRepo}/archive/${revision}.tar.gz`,
    true,
  );
  const downloads = sourceArchives(source).map((archive) => ({
    ...archive,
    hash: prefetch(archive.url).hash,
  }));
  const bootstrapAssets: Record<string, BootstrapPin> = Object.fromEntries(
    Object.entries(bootstrapNames).map(([platform, name]) => [
      platform,
      { name, hash: prefetch(bootstrapUrl(version, name)).hash },
    ]),
  );
  const webkit = pinWebKit(source, current.webkit, values.force);
  const vendorHash = cargoHash(version, source);
  const platform = output("nix", [
    "eval",
    "--impure",
    "--raw",
    "--expr",
    `
let pkgs = import ./. {}; in
pkgs.stdenv.buildPlatform.system
+ pkgs.lib.optionalString pkgs.stdenv.buildPlatform.isMusl "-musl"
`,
  ]);
  const asset = bootstrapAssets[platform];
  if (!asset)
    throw new Error(`Unsupported Bun bootstrap platform: ${platform}`);
  const bootstrap = bootstrapPath(version, asset);
  saveSources({
    version,
    revision,
    sourceHash,
    cargoHash: vendorHash,
    bootstrapAssets,
    nodeModulesHashes: nodeModulesHashes(source, bootstrap),
    downloads,
    webkit,
  });
  console.log(`Updated ${sourcesFile}`);
}

main();
