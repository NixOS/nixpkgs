import { getScopedName } from "../utils.ts";

type Config = LockfileTransformerConfig;
function getConfig(): Config {
  const flagsParsed = {
    "in-path": "",
    "in-path-ts-types": "",
    "out-path-jsr": "",
    "out-path-npm": "",
    "out-path-https": "",
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

  const tsTypesJson: TsTypesJson = JSON.parse(
    new TextDecoder().decode(
      Deno.readFileSync(flagsParsed["in-path-ts-types"]),
    ),
  );

  const lockfile = JSON.parse(
    new TextDecoder("utf-8").decode(
      Deno.readFileSync(flagsParsed["in-path"]),
    ),
  );
  const tsTypes = transformTsTypes(tsTypesJson);

  lockfile.jsr = { ...tsTypes.jsr, ...lockfile.jsr };
  lockfile.remote = { ...tsTypes.remote, ...lockfile.remote };
  lockfile.npm = { ...tsTypes.npm, ...lockfile.npm };

  return {
    lockfile,
    outPathJsr: flagsParsed["out-path-jsr"],
    outPathNpm: flagsParsed["out-path-npm"],
    outPathHttps: flagsParsed["out-path-https"],
    inPathTsTypes: flagsParsed["in-path-ts-types"],
    inPath: flagsParsed["in-path"],
  };
}

function transformTsTypes(
  tsTypes: TsTypesJson,
): Pick<DenoLock, "jsr" | "npm" | "remote"> {
  const result: Pick<DenoLock, "jsr" | "npm" | "remote"> = {
    jsr: {},
    npm: {},
    remote: {},
  };
  for (const packageSpecifier of tsTypes) {
    if (packageSpecifier.match(/^https?:/)) {
      result.remote[packageSpecifier] = "";
    } else if (packageSpecifier.match(/^jsr:/)) {
      result.jsr[packageSpecifier] = { integrity: "", dependencies: [] };
    } else if (packageSpecifier.match(/^npm:/)) {
      result.npm[packageSpecifier] = {
        integrity: "",
        optionalDependencies: [],
        dependencies: [],
      };
    } else {
      throw new Error(
        `Invalid package specifier received from ts-types-preprocessor: ${packageSpecifier}`,
      );
    }
  }
  return result;
}

function parsePackageSpecifier(fullString: string): PackageSpecifier {
  const matches = fullString.match(/^((.+):)?(@(.+)\/)?(.+)$/);
  if (!matches) {
    throw new Error(`Invalid package specifier: ${fullString}`);
  }
  const registry = matches[2] || null;
  const scope = matches[4] || null;
  const nameVersionSuffix = matches[5];
  const split = nameVersionSuffix.split("_");
  const nameVersionMatch = split[0].match(/^(.+)@(.+)$/);
  if (!nameVersionMatch) {
    throw new Error(`Invalid name@version format (version is required) in: "${split[0]}" in string "${fullString}"`);
  }
  const name = nameVersionMatch[1];
  const version = nameVersionMatch[2];
  const suffix = split.length === 1 ? null : split.slice(1).join("_");
  return { fullString, registry, scope, name, version, suffix };
}

function makeVersionMetaJsonUrl(packageSpecifier: PackageSpecifier): UrlString {
  return `https://jsr.io/${getScopedName(packageSpecifier)}/${packageSpecifier.version}_meta.json`;
}

function makeNpmPackageUrl(packageSpecifier: PackageSpecifier): UrlString {
  return `https://registry.npmjs.org/${getScopedName(packageSpecifier)}/-/${packageSpecifier.name}-${packageSpecifier.version}.tgz`;
}

function makeJsrCommonLock(denolock: DenoLock): CommonLockFormatIn {
  const result: CommonLockFormatIn = [];
  if (!denolock.jsr) {
    return [];
  }
  Object.entries(denolock.jsr).forEach(([key, value]) => {
    const packageSpecifier = parsePackageSpecifier(key);
    const registry = "jsr";
    packageSpecifier.registry = registry;
    const url = makeVersionMetaJsonUrl(packageSpecifier);
    const hash = value.integrity;
    const hashAlgo = "sha256";
    result.push({
      url,
      hash,
      hashAlgo,
      meta: {
        registry,
        packageSpecifier,
      },
    });
  });
  return result;
}

function makeNpmCommonLock(denolock: DenoLock): CommonLockFormatIn {
  const result: CommonLockFormatIn = [];
  if (!denolock.npm) {
    return [];
  }
  Object.entries(denolock.npm).forEach(([key, value]) => {
    const packageSpecifier = parsePackageSpecifier(key);
    const registry = "npm";
    packageSpecifier.registry = registry;
    const url = makeNpmPackageUrl(packageSpecifier);
    const hash = value.integrity;
    const hashAlgo = "sha512";
    result.push({
      url,
      hash,
      hashAlgo,
      meta: {
        registry,
        packageSpecifier,
      },
    });
  });
  return result;
}

function getRegistry(url: UrlString): string {
  return new URL(url).host;
}

function transformHttpsPackageFile(p: PackageFileIn): PackageFileIn {
  const transformers: Record<string, (p: PackageFileIn) => PackageFileIn> = {
    "esm.sh": function (p: PackageFileIn): PackageFileIn {
      const result = structuredClone(p);
      const url = new URL(result.url);
      if (!url.searchParams.has("target")) {
        url.searchParams.set("target", "denonext");
      }
      result.url = url.toString();
      result.meta = { ...p.meta, original: structuredClone(p) };
      return result;
    },
    default: function (p: PackageFileIn): PackageFileIn {
      return p;
    },
  };
  function pickTransformer(p: PackageFileIn): PackageFileIn {
    const transformer =
      transformers[p.meta.registry] || transformers["default"];
    return transformer(p);
  }
  return pickTransformer(p);
}

function makeHttpsCommonLock(denolock: DenoLock): CommonLockFormatIn {
  const result: Record<string, PackageFileIn> = {};
  if (!denolock.remote) {
    return [];
  }
  if (denolock.redirects) {
    Object.entries(denolock.redirects).forEach(([original, redirect]) => {
      const url = redirect;
      const registry = getRegistry(url);
      const hash = "";
      const hashAlgo = "sha256";
      result[url] = transformHttpsPackageFile({
        url,
        hash,
        hashAlgo,
        meta: {
          registry,
        },
      });
    });
  }
  Object.entries(denolock.remote).forEach(([url, hash]) => {
    const registry = getRegistry(url);
    const hashAlgo = "sha256";
    result[url] = transformHttpsPackageFile({
      url,
      hash,
      hashAlgo,
      meta: {
        registry,
      },
    });
  });

  return Object.values(result);
}

async function main() {
  const config = getConfig();
  const transformedLockJsr = makeJsrCommonLock(config.lockfile);
  const transformedLockNpm = makeNpmCommonLock(config.lockfile);
  const transformedLockHttps = makeHttpsCommonLock(config.lockfile);
  const promises = [
    Deno.writeTextFile(config.outPathJsr, JSON.stringify(transformedLockJsr)),
    Deno.writeTextFile(config.outPathNpm, JSON.stringify(transformedLockNpm)),
    Deno.writeTextFile(
      config.outPathHttps,
      JSON.stringify(transformedLockHttps),
    ),
  ];
  await Promise.all(promises);
}

if (import.meta.main) {
  main();
}
