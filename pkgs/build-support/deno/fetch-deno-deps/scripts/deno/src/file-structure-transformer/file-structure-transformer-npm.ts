/**
 * cli entrypoint for the npm file structure transformer
 * see readme.md -> "NPM Packages"
 * see readme.md -> "Architecture"
 */

import { addPrefix, getBasePath, getScopedName, parseArgs } from "../utils.ts";
import type {
  CommonLockFormatOut,
  PackageSpecifier,
  ParsedArgs,
  ParsedArgsNames,
  PathString,
  UnparsedArgs,
} from "../types.d.ts";

type FileTransformerNpmConfig = {
  commonLockNpmPath: PathString;
  inBasePath: PathString;
  denoDirPath: PathString;
  commonLockNpm: CommonLockFormatOut;
  rootPath: PathString;
};

type Config = FileTransformerNpmConfig;
function getConfig(): Config {
  interface ArgNames extends ParsedArgsNames {
    commonLockNpmPath: null;
    denoDirPath: null;
  }

  const unparsedArgs: UnparsedArgs<ArgNames> = {
    commonLockNpmPath: {
      flag: "--common-lock-npm-path",
      defaultValue: "",
    },
    denoDirPath: {
      flag: "--deno-dir-path",
      defaultValue: "",
    },
  };

  const parsedArgs: ParsedArgs<ArgNames> = parseArgs(unparsedArgs, Deno.args);

  return {
    commonLockNpm: JSON.parse(
      Deno.readTextFileSync(parsedArgs.commonLockNpmPath.value),
    ),
    denoDirPath: parsedArgs.denoDirPath.value,
    commonLockNpmPath: parsedArgs.commonLockNpmPath.value,
    inBasePath: getBasePath(parsedArgs.commonLockNpmPath.value),
    rootPath: `${parsedArgs.denoDirPath.value}/npm/registry.npmjs.org`,
  };
}

/**
 * see readme.md -> "Package `tarball`"
 */
function makePackagePath(
  root: PathString,
  packageSpecifier: PackageSpecifier,
): PathString {
  return `${root}/${
    getScopedName(packageSpecifier)
  }/${packageSpecifier.version}`;
}

/**
 * see readme.md -> "`registry.json`"
 */
function makeRegistryJsonPath(
  root: PathString,
  packageSpecifier: PackageSpecifier,
): PathString {
  return `${root}/${getScopedName(packageSpecifier)}/registry.json`;
}

async function extractTarball(
  config: Config,
  packageSpecifier: PackageSpecifier,
  fetcherOutPath: PathString,
) {
  const outPath = makePackagePath(config.rootPath, packageSpecifier);
  await Deno.mkdir(outPath, { recursive: true });
  // we need to extract the tarball, but we can't use any js libraries,
  // so we need to use the `tar` cli
  const command = new Deno.Command("tar", {
    args: ["-C", outPath, "-xzf", fetcherOutPath, "--strip-components=1"],
  });
  await command.output();
}

/**
 * see readme.md -> "Package `tarball`"
 */
async function transformFilesNpm(config: Config) {
  for await (const packageFile of config.commonLockNpm) {
    const packageSpecifier = packageFile?.meta?.packageSpecifier;
    if (!packageSpecifier) {
      throw `packageSpecifier required but not found in ${
        JSON.stringify(packageFile)
      }`;
    }

    const inPath = addPrefix(packageFile.outPath, config.inBasePath);
    if (packageFile.url.endsWith("registry.json")) {
      const outPath = makeRegistryJsonPath(config.rootPath, packageSpecifier);
      await Deno.copyFile(inPath, outPath);
    } else {
      await extractTarball(config, packageSpecifier, inPath);
    }
  }
}

async function main() {
  const config = getConfig();
  await transformFilesNpm(config);
}

if (import.meta.main) {
  main();
}
