/**
 * cli entrypoint for the deno lock file transformer
 * see readme.md -> "`deno.lock`"
 * see readme.md -> "Architecture"
 */

import { getScopedName, parseArgs } from "../utils.ts";
import type {
  CommonLockFormatIn,
  DenoLock,
  Hash,
  PackageFileIn,
  PackageSpecifier,
  ParsedArgs,
  ParsedArgsNames,
  PathString,
  UnparsedArgs,
  UrlString,
} from "../types.d.ts";

type LockfileTransformerConfig = {
  denoLockPath: PathString;
  commonLockJsrPath: PathString;
  commonLockNpmPath: PathString;
  commonLockHttpsPath: PathString;
  lockfile: DenoLock;
};

type Config = LockfileTransformerConfig;
function getConfig(): Config {
  interface ArgNames extends ParsedArgsNames {
    denoLockPath: null;
    commonLockJsrPath: null;
    commonLockHttpsPath: null;
    commonLockNpmPath: null;
  }

  const unparsedArgs: UnparsedArgs<ArgNames> = {
    denoLockPath: {
      flag: "--deno-lock-path",
      defaultValue: "",
    },
    commonLockJsrPath: {
      flag: "--common-lock-jsr-path",
      defaultValue: "",
    },
    commonLockHttpsPath: {
      flag: "--common-lock-https-path",
      defaultValue: "",
    },
    commonLockNpmPath: {
      flag: "--common-lock-npm-path",
      defaultValue: "",
    },
  };

  const parsedArgs: ParsedArgs<ArgNames> = parseArgs(unparsedArgs, Deno.args);

  return {
    lockfile: JSON.parse(
      new TextDecoder("utf-8").decode(
        Deno.readFileSync(parsedArgs.denoLockPath.value),
      ),
    ),
    commonLockJsrPath: parsedArgs.commonLockJsrPath.value,
    commonLockNpmPath: parsedArgs.commonLockNpmPath.value,
    commonLockHttpsPath: parsedArgs.commonLockHttpsPath.value,
    denoLockPath: parsedArgs.denoLockPath.value,
  };
}

/**
 * we need to parse a deno package specifier into a usable object
 * see `lockfile-transformer.test.ts` for the spec
 */
export function parsePackageSpecifier(fullString: string): PackageSpecifier {
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

/**
 * see readme.md -> "`<version>_meta.json`"
 */
function makeVersionMetaJsonUrl(packageSpecifier: PackageSpecifier): UrlString {
  return `https://jsr.io/${
    getScopedName(packageSpecifier)
  }/${packageSpecifier.version}_meta.json`;
}
/**
 * see readme.md -> "The actual package files"
 */
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
    const hash: Hash = {
      string: value.integrity,
      algorithm: "sha256",
      encoding: "hex",
    };
    result.push({
      url,
      hash,
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
    const hash: Hash = {
      string: value.integrity,
      algorithm: "sha512",
      encoding: "base64",
    };
    result.push({
      url,
      hash,
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

/**
 * used for edge cases for https packages
 * see readme.md -> "Architecture"
 */
function transformHttpsPackageFile(p: PackageFileIn): PackageFileIn {
  const transformers: Record<string, (p: PackageFileIn) => PackageFileIn> = {
    // special case for esm.sh,
    // see readme.md -> "`esm.sh`"
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
  Object.entries(denolock.remote).forEach(([url, integrity]) => {
    const registry = getRegistry(url);
    const hash: Hash = {
      string: integrity,
      algorithm: "sha256",
      encoding: "hex",
    };
    result[url] = transformHttpsPackageFile({
      url,
      hash,
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

/**
 * we need to construct abstract lockfiles from the `deno.lock`, decoupled from deno upstream
 * see readme.md -> "Architecture"
 */
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
    config.commonLockJsrPath,
    config.commonLockNpmPath,
    config.commonLockHttpsPath,
    transformedLocks,
  );
}

if (import.meta.main) {
  main();
}
