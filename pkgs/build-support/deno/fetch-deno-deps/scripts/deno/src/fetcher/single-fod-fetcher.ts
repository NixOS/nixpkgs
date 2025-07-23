// TODO: use the hashes from the lockfile to verify integrity of downloads,
// the problem is that the hashes use different encoding schemes, while `fetch`
// expects a specific one, so some translation needs to happen, without any from the network.

import { fetchAllJsr } from "./fetch-jsr.ts";
import { fetchAllNpm } from "./fetch-npm.ts";
import { addPrefix } from "../utils.ts";
import { fetchAllHttps } from "./fetch-https.ts";

type Config = SingleFodFetcherConfig;
function getConfig(): Config {
  const flagsParsed = {
    "in-path-jsr": "",
    "in-path-npm": "",
    "in-path-https": "",
    "out-path-vendored": "",
    "out-path-npm": "",
    "out-path-prefix": "",
  };
  const flags = Object.keys(flagsParsed).map((v) => "--" + v);
  Deno.args.forEach((arg, index) => {
    if (flags.includes(arg) && Deno.args.length > index + 1) {
      flagsParsed[arg.replace(/^--/g, "") as keyof typeof flagsParsed] =
        Deno.args[index + 1];
    }
  });

  Object.entries(flagsParsed).forEach(([key, value]) => {
    if (value === "") {
      throw `--${key} flag not set but required`;
    }
  });

  return {
    commonLockfileJsr: JSON.parse(
      new TextDecoder().decode(Deno.readFileSync(flagsParsed["in-path-jsr"])),
    ),
    commonLockfileNpm: JSON.parse(
      new TextDecoder().decode(Deno.readFileSync(flagsParsed["in-path-npm"])),
    ),
    commonLockfileHttps: JSON.parse(
      new TextDecoder().decode(Deno.readFileSync(flagsParsed["in-path-https"])),
    ),
    outPathVendored: flagsParsed["out-path-vendored"],
    outPathNpm: flagsParsed["out-path-npm"],
    inPathJsr: flagsParsed["in-path-jsr"],
    inPathNpm: flagsParsed["in-path-npm"],
    inPathHttps: flagsParsed["in-path-https"],
    outPathPrefix: flagsParsed["out-path-prefix"] || "",
  };
}

type Lockfiles = { vendor: CommonLockFormatOut; npm: CommonLockFormatOut };
async function fetchAll(config: Config): Promise<Lockfiles> {
  const lockfilesByRegistry = {
    jsr: await fetchAllJsr(config),
    https: await fetchAllHttps(config),
    npm: await fetchAllNpm(config),
  };

  const lockfilesByCache = {
    vendor: lockfilesByRegistry.jsr.concat(lockfilesByRegistry.https),
    npm: lockfilesByRegistry.npm,
  };

  return lockfilesByCache;
}

async function main() {
  const config = getConfig();
  await Deno.mkdir(config.outPathPrefix, { recursive: true });
  const lockfiles = await fetchAll(config);
  await Deno.writeTextFile(
    addPrefix(config.outPathVendored, config.outPathPrefix),
    JSON.stringify(lockfiles.vendor),
    { create: true },
  );
  await Deno.writeTextFile(
    addPrefix(config.outPathNpm, config.outPathPrefix),
    JSON.stringify(lockfiles.npm),
    { create: true },
  );
}

if (import.meta.main) {
  main();
}
