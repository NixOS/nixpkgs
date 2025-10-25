// TODO: use the hashes from the lockfile to verify integrity of downloads,
// the problem is that the hashes use different encoding schemes, while `fetch`
// expects a specific one, so some translation needs to happen, without any from the network.

import { fetchAllJsr } from "./fetch-jsr.ts";
import { fetchAllNpm } from "./fetch-npm.ts";
import { addPrefix } from "../utils.ts";
import { fetchAllHttps } from "./fetch-https.ts";
import type {
  CommonLockFormatIn,
  CommonLockFormatOut,
  PathString,
} from "../types.d.ts";

type SingleFodFetcherConfig = {
  outPathPrefix: PathString;
  inPathJsr: PathString;
  inPathNpm: PathString;
  inPathHttps: PathString;
  inJsrRegistryUrl: string;
  outPathVendored: PathString;
  outPathNpm: PathString;
  commonLockfileJsr: CommonLockFormatIn;
  commonLockfileNpm: CommonLockFormatIn;
  commonLockfileHttps: CommonLockFormatIn;
};

type Config = SingleFodFetcherConfig;
function getConfig(): Config {
  const flagsParsed = {
    "in-path-jsr": "",
    "in-path-npm": "",
    "in-path-https": "",
    "in-jsr-registry-url": "https://jsr.io",
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

  const dec = new TextDecoder();
  return {
    commonLockfileJsr: JSON.parse(
      dec.decode(Deno.readFileSync(flagsParsed["in-path-jsr"])),
    ),
    commonLockfileNpm: JSON.parse(
      dec.decode(Deno.readFileSync(flagsParsed["in-path-npm"])),
    ),
    commonLockfileHttps: JSON.parse(
      dec.decode(Deno.readFileSync(flagsParsed["in-path-https"])),
    ),
    outPathVendored: flagsParsed["out-path-vendored"],
    outPathNpm: flagsParsed["out-path-npm"],
    inPathJsr: flagsParsed["in-path-jsr"],
    inPathNpm: flagsParsed["in-path-npm"],
    inPathHttps: flagsParsed["in-path-https"],
    inJsrRegistryUrl: flagsParsed["in-jsr-registry-url"],
    outPathPrefix: flagsParsed["out-path-prefix"] || "",
  };
}

type Lockfiles = { vendor: CommonLockFormatIn; npm: CommonLockFormatOut };
async function fetchAll(config: Config): Promise<Lockfiles> {
  const lockfilesByRegistry = {
    jsr: await fetchAllJsr(
      config.outPathPrefix,
      config.commonLockfileJsr,
      config.inJsrRegistryUrl,
    ),
    https: await fetchAllHttps(
      config.outPathPrefix,
      config.commonLockfileHttps,
    ),
    npm: await fetchAllNpm(config.outPathPrefix, config.commonLockfileNpm),
  };

  const lockfilesByCache = {
    vendor: lockfilesByRegistry.jsr.concat(lockfilesByRegistry.https),
    npm: lockfilesByRegistry.npm,
  };

  return lockfilesByCache;
}

async function fetchAndWrite(config: Config) {
  await Deno.mkdir(config.outPathPrefix, { recursive: true });
  const lockfiles = await fetchAll(config);
  const promises = [
    Deno.writeTextFile(
      addPrefix(config.outPathVendored, config.outPathPrefix),
      JSON.stringify(lockfiles.vendor, null, 2),
      { create: true },
    ),
    Deno.writeTextFile(
      addPrefix(config.outPathNpm, config.outPathPrefix),
      JSON.stringify(lockfiles.npm, null, 2),
      { create: true },
    ),
  ];
  await Promise.all(promises);
}

async function main() {
  const config = getConfig();
  await fetchAndWrite(config);
}

if (import.meta.main) {
  main();
}
