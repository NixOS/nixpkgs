import { addPrefix, getBasePath, getScopedName } from "../utils.ts";

type Config = FileTransformerNpmConfig;
function getConfig(): Config {
  const flagsParsed = {
    "in-path": "",
    "cache-path": "",
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
    commonLockfile: JSON.parse(
      new TextDecoder("utf-8").decode(
        Deno.readFileSync(flagsParsed["in-path"]),
      ),
    ),
    cachePath: flagsParsed["cache-path"],
    inPath: flagsParsed["in-path"],
    inBasePath: getBasePath(flagsParsed["in-path"]),
    rootPath: `${flagsParsed["cache-path"]}/npm/registry.npmjs.org`,
  };
}

function makePackagePath(
  root: PathString,
  packageSpecifier: PackageSpecifier,
): PathString {
  return `${root}/${getScopedName(packageSpecifier)}/${packageSpecifier.version}`;
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
  for await (const packageFile of config.commonLockfile) {
    const packageSpecifier = packageFile?.meta?.packageSpecifier;
    if (!packageSpecifier) {
      throw `packageSpecifier required but not found in ${JSON.stringify(packageFile)}`;
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
