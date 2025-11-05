// TODO: use the hashes from the lockfile to verify integrity of downloads,
// the problem is that the hashes use different encoding schemes, while `fetch`
// expects a specific one, so some translation needs to happen, without any from the network.

import { fetchAllJsr } from "./fetch-jsr.ts";
import { fetchAllNpm } from "./fetch-npm.ts";
import { addPrefix, getFileName } from "../utils.ts";
import { fetchAllHttps } from "./fetch-https.ts";
import type {
  CommonLockFormatIn,
  CommonLockFormatOut,
  PathString,
} from "../types.d.ts";

type SingleFodFetcherConfig = {
  outPathPrefix: PathString;
  commonLockJsrPath: PathString;
  commonLockNpmPath: PathString;
  commonLockHttpsPath: PathString;
  jsrRegistryUrl: string;
  commonLockJsr: CommonLockFormatIn;
  commonLockNpm: CommonLockFormatIn;
  commonLockHttps: CommonLockFormatIn;
};

type Config = SingleFodFetcherConfig;
function getConfig(): Config {
  const flagsParsed = {
    "common-lock-jsr-path": "",
    "common-lock-npm-path": "",
    "common-lock-https-path": "",
    "jsr-registry-url": "https://jsr.io",
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
    commonLockJsr: JSON.parse(
      Deno.readTextFileSync(flagsParsed["common-lock-jsr-path"]),
    ),
    commonLockNpm: JSON.parse(
      Deno.readTextFileSync(flagsParsed["common-lock-npm-path"]),
    ),
    commonLockHttps: JSON.parse(
      Deno.readTextFileSync(flagsParsed["common-lock-https-path"]),
    ),
    commonLockJsrPath: flagsParsed["common-lock-jsr-path"],
    commonLockNpmPath: flagsParsed["common-lock-npm-path"],
    commonLockHttpsPath: flagsParsed["common-lock-https-path"],
    jsrRegistryUrl: flagsParsed["jsr-registry-url"],
    outPathPrefix: flagsParsed["out-path-prefix"] || "",
  };
}

type Lockfiles = {
  jsr: CommonLockFormatIn;
  https: CommonLockFormatIn;
  npm: CommonLockFormatOut;
};
async function fetchAll(config: Config): Promise<Lockfiles> {
  const lockfilesByRegistry: Lockfiles = {
    jsr: await fetchAllJsr(
      config.outPathPrefix,
      config.commonLockJsr,
      config.jsrRegistryUrl,
    ),
    https: await fetchAllHttps(
      config.outPathPrefix,
      config.commonLockHttps,
    ),
    npm: await fetchAllNpm(config.outPathPrefix, config.commonLockNpm),
  };

  return lockfilesByRegistry;
}

async function fetchAndWrite(config: Config) {
  await Deno.mkdir(config.outPathPrefix, { recursive: true });
  const lockfiles = await fetchAll(config);
  const promises = [
    Deno.writeTextFile(
      addPrefix(getFileName(config.commonLockJsrPath), config.outPathPrefix),
      JSON.stringify(lockfiles.jsr, null, 2),
      { create: true },
    ),
    Deno.writeTextFile(
      addPrefix(getFileName(config.commonLockHttpsPath), config.outPathPrefix),
      JSON.stringify(lockfiles.https, null, 2),
      { create: true },
    ),
    Deno.writeTextFile(
      addPrefix(getFileName(config.commonLockNpmPath), config.outPathPrefix),
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
