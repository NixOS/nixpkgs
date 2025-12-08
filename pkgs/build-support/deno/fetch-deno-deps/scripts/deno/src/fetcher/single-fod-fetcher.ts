import { fetchAllJsr } from "./fetch-jsr.ts";
import { fetchAllNpm } from "./fetch-npm.ts";
import { addPrefix, getFileName, parseArgs } from "../utils.ts";
import { fetchAllHttps } from "./fetch-https.ts";
import type {
  CommonLockFormatIn,
  CommonLockFormatOut,
  ParsedArgs,
  ParsedArgsNames,
  PathString,
  UnparsedArgs,
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
  interface ArgNames extends ParsedArgsNames {
    commonLockJsrPath: null;
    commonLockNpmPath: null;
    commonLockHttpsPath: null;
    jsrRegistryUrl: null;
    outPathPrefix: null;
  };

  const unparsedArgs: UnparsedArgs<ArgNames> = {
    commonLockJsrPath: {
      flag: "--common-lock-jsr-path",
      defaultValue: "",
    },
    commonLockNpmPath: {
      flag: "--common-lock-npm-path",
      defaultValue: "",
    },
    commonLockHttpsPath: {
      flag: "--common-lock-https-path",
      defaultValue: "",
    },
    jsrRegistryUrl: {
      flag: "--jsr-registry-url",
      defaultValue: "https://jsr.io",
    },
    outPathPrefix: {
      flag: "--out-path-prefix",
      defaultValue: "",
    },
  };

  const parsedArgs: ParsedArgs<ArgNames> = parseArgs(unparsedArgs, Deno.args);

  return {
    commonLockJsr: JSON.parse(
      Deno.readTextFileSync(parsedArgs.commonLockJsrPath.value),
    ),
    commonLockNpm: JSON.parse(
      Deno.readTextFileSync(parsedArgs.commonLockNpmPath.value),
    ),
    commonLockHttps: JSON.parse(
      Deno.readTextFileSync(parsedArgs.commonLockHttpsPath.value),
    ),
    commonLockJsrPath: parsedArgs.commonLockJsrPath.value,
    commonLockNpmPath: parsedArgs.commonLockNpmPath.value,
    commonLockHttpsPath: parsedArgs.commonLockHttpsPath.value,
    jsrRegistryUrl: parsedArgs.jsrRegistryUrl.value,
    outPathPrefix: parsedArgs.outPathPrefix.value,
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
