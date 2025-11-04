import { addPrefix, getBasePath, getScopedName } from "../utils.ts";
import type {
  CommonLockFormatOut,
  PackageSpecifier,
  PathString,
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
  const flagsParsed = {
    "common-lock-npm-path": "",
    "deno-dir-path": "",
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
    commonLockNpm: JSON.parse(
      Deno.readTextFileSync(flagsParsed["common-lock-npm-path"]),
    ),
    denoDirPath: flagsParsed["deno-dir-path"],
    commonLockNpmPath: flagsParsed["common-lock-npm-path"],
    inBasePath: getBasePath(flagsParsed["common-lock-npm-path"]),
    rootPath: `${flagsParsed["deno-dir-path"]}/npm/registry.npmjs.org`,
  };
}

function makePackagePath(
  root: PathString,
  packageSpecifier: PackageSpecifier,
): PathString {
  return `${root}/${
    getScopedName(packageSpecifier)
  }/${packageSpecifier.version}`;
}

function makeRegistryJsonPath(
  root: PathString,
  packageSpecifier: PackageSpecifier,
): PathString {
  return `${root}/${getScopedName(packageSpecifier)}/registry.json`;
}

async function unpackPackage(
  config: Config,
  packageSpecifier: PackageSpecifier,
  fetcherOutPath: PathString,
) {
  const outPath = makePackagePath(config.rootPath, packageSpecifier);
  await Deno.mkdir(outPath, { recursive: true });
  const command = new Deno.Command("tar", {
    args: ["-C", outPath, "-xzf", fetcherOutPath, "--strip-components=1"],
  });
  await command.output();
}

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
      await unpackPackage(config, packageSpecifier, inPath);
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
