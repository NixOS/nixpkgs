import { getScopedName } from "../utils.ts";
import type {
  CommonLockFormatIn,
  DenoLock,
  PackageFileIn,
  PackageSpecifier,
  PathString,
  UrlString,
} from "../types.d.ts";

type LockfileTransformerConfig = {
  inPath: PathString;
  outPathJsr: PathString;
  outPathNpm: PathString;
  outPathHttps: PathString;
  lockfile: DenoLock;
};

type Config = LockfileTransformerConfig;
function getConfig(): Config {
  const flagsParsed = {
    "in-path": "",
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

  return {
    lockfile: JSON.parse(
      new TextDecoder("utf-8").decode(
        Deno.readFileSync(flagsParsed["in-path"]),
      ),
    ),
    outPathJsr: flagsParsed["out-path-jsr"],
    outPathNpm: flagsParsed["out-path-npm"],
    outPathHttps: flagsParsed["out-path-https"],
    inPath: flagsParsed["in-path"],
  };
}

export function parsePackageSpecifier(fullString: string): PackageSpecifier {
  // see `lockfile-transformer.test.ts` for the spec
  const matches = fullString.match(
    /^(([^:]+):)?(@([^\/]+)\/)?([^@]+)@([^_]+)(_.*)?$/,
  );
  if (!matches) {
    throw new Error(`Invalid package specifier: ${fullString}`);
  }
  const [, , registry, , scope, name, version, suffix] = matches;
  return {
    fullString,
    registry: registry || null,
    scope: scope || null,
    name,
    version,
    suffix: suffix || null,
  };
}

function makeVersionMetaJsonUrl(packageSpecifier: PackageSpecifier): UrlString {
  return `https://jsr.io/${
    getScopedName(packageSpecifier)
  }/${packageSpecifier.version}_meta.json`;
}

function makeNpmPackageUrl(packageSpecifier: PackageSpecifier): UrlString {
  return `https://registry.npmjs.org/${
    getScopedName(packageSpecifier)
  }/-/${packageSpecifier.name}-${packageSpecifier.version}.tgz`;
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
    // special case for esm.sh, see readme.md
    "esm.sh": function (p: PackageFileIn): PackageFileIn {
      const result = structuredClone(p);
      const url = new URL(result.url);
      if (!url.searchParams.has("target")) {
        url.searchParams.set("target", "denonext");
      }
      result.url = url.toString();
      result.meta = { ...p.meta, original_url: p.url };
      return result;
    },
    default: function (p: PackageFileIn): PackageFileIn {
      return p;
    },
  };
  function pickTransformer(p: PackageFileIn): PackageFileIn {
    const transformer = transformers[p.meta.registry] ||
      transformers["default"];
    return transformer(p);
  }
  return pickTransformer(p);
}

function makeHttpsCommonLock(denolock: DenoLock): CommonLockFormatIn {
  const result: Record<string, PackageFileIn> = {};
  if (!denolock.remote) {
    return [];
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

type TransformedLocks = {
  jsr: CommonLockFormatIn;
  npm: CommonLockFormatIn;
  https: CommonLockFormatIn;
};
function transformAll(lockfile: DenoLock): TransformedLocks {
  return {
    jsr: makeJsrCommonLock(lockfile),
    npm: makeNpmCommonLock(lockfile),
    https: makeHttpsCommonLock(lockfile),
  };
}

async function writeAll(
  outPathJsr: PathString,
  outPathNpm: PathString,
  outPathHttps: PathString,
  transformedLocks: TransformedLocks,
) {
  const promises = [
    Deno.writeTextFile(
      outPathJsr,
      JSON.stringify(transformedLocks.jsr, null, 2),
    ),
    Deno.writeTextFile(
      outPathNpm,
      JSON.stringify(transformedLocks.npm, null, 2),
    ),
    Deno.writeTextFile(
      outPathHttps,
      JSON.stringify(transformedLocks.https, null, 2),
    ),
  ];
  await Promise.all(promises);
}

const knownVersions = ["4", "5"];

function checkVersion(lockfile: DenoLock) {
  if (!knownVersions.includes(lockfile.version)) {
    console.error(`
      WARNING: using deno.lock with a version unknown by nixpkgs buildDenoPackage: "${lockfile.version}"

      The build might fail because of this.

      Consider creating an issue in nixpkgs, if it there is not already one for that version.
`);
  }
}

async function main() {
  const config = getConfig();
  checkVersion(config.lockfile);
  const transformedLocks = transformAll(config.lockfile);
  await writeAll(
    config.outPathJsr,
    config.outPathNpm,
    config.outPathHttps,
    transformedLocks,
  );
}

if (import.meta.main) {
  main();
}
