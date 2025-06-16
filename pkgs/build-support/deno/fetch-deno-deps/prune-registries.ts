#!/usr/bin/env deno
import { parseArgs } from "@std/cli/parse-args";
import { walkSync } from "@std/fs/walk";

/**
 * NOTE: The problem this script solves, is that in every npm dependency in the deno cache
 * is a registry.json file, which serves as a sort of local registry cache for the deno cli.
 * Such a file looks like this (with deno v2.1.4):
 * ```json
 * {
 *   "name": "@floating-ui/core",
 *   "versions": {
 *     "0.7.0": { ... },
 *     "1.6.0": { ... },
 *     "0.1.2": { ... },
 *     ...
 *   },
 *   "dist-tags": { "latest": "1.7.0" }
 * }
 * ```
 * The deno cli will look into this file when called to look up if the required versions are there.
 * The problem is that the available versions for a package change over time. The registry.json files
 * need to be part of the fixed output derivation, which will eventually change the hash of the FOD,
 * if all those unwanted versions aren't pruned.
 *
 * On top of that a similar thing happens for jsr packages in the vendor directory
 * with `meta.json` files. These also need to be pruned.
 * Such a file looks like this (with deno v2.1.4):
 * ```json
 * {
 *   "scope": "std",
 *   "name": "internal",
 *   "latest": "1.0.6",
 *   "versions": {
 *     "0.202.0": {},
 *     "1.0.1": {},
 *     "0.225.0": {
 *       "yanked": true
 *     },
 * }
 * ```
 */

export type PackageSpecifiers = {
  [packageIdent: string]: string;
};

export type LockJson = {
  specifiers: PackageSpecifiers;
  version: string;
  workspace: any;
  [registry: string]: any;
};

export type Config = {
  lockJson: LockJson;
  cachePath: string;
  vendorPath: string;
};

export type PackageInfo = {
  full: string;
  registry: string | undefined;
  scope: string | undefined;
  name: string;
  version: string;
  suffix: string | undefined;
};

export type PackagesByRegistry = {
  [registry: string]: {
    [packageName: string]: {
      [version: string]: PackageInfo;
    };
  };
};

export type PathsByRegistry = {
  [packageRegistry: string]: string[];
};

export type RegistryJson = {
  "dist-tags": any;
  "_deno.etag": string;
  versions: { [version: string]: any };
  name: string;
};

export type MetaJson = {
  scope: string;
  name: string;
  latest: string;
  versions: {
    [version: string]: any;
  };
};

export function getConfig(): Config {
  const flags = parseArgs(Deno.args, {
    string: ["lock-json", "cache-path", "vendor-path"],
  });

  if (!flags["lock-json"]) {
    throw "--lock-json flag not set but required";
  }
  if (!flags["cache-path"]) {
    throw "--cache-path flag not set but required";
  }
  if (!flags["vendor-path"]) {
    throw "--vendor-path flag not set but required";
  }

  const lockJson = JSON.parse(
    new TextDecoder("utf-8").decode(Deno.readFileSync(flags["lock-json"]))
  );
  if (!lockJson) {
    throw `could not parse lockJson at ${flags["lock-json"]}`;
  }

  return {
    lockJson,
    cachePath: flags["cache-path"],
    vendorPath: flags["vendor-path"],
  };
}

export function getAllPackageRegistries(
  specifiers: PackageSpecifiers
): Set<string> {
  return Object.keys(specifiers).reduce((acc: Set<string>, v: string) => {
    const s = v.split(":");
    if (s.length !== 2) {
      throw "unexpected registry format";
    }
    const registry = s[0];
    acc.add(registry);
    return acc;
  }, new Set());
}

export function parsePackageSpecifier(packageSpecifier: string): PackageInfo {
  const match =
    /^((?<registry>.*):)?((?<scope>@.*?)\/)?(?<name>.*?)@(?<version>.*?)(?<suffix>_.*)?$/.exec(
      packageSpecifier
    );
  if (
    match !== null &&
    match.groups?.name !== undefined &&
    match.groups?.version !== undefined
  ) {
    return {
      // npm:@amazn/style-dictionary@4.2.4_prettier@3.5.3
      full: match[0],
      // npm
      registry: match.groups?.registry,
      // @amazn
      scope: match.groups?.scope,
      // style-dictionary
      name: match.groups?.name,
      // 4.2.4
      version: match.groups?.version,
      // _prettier@3.5.3
      suffix: match.groups?.suffix,
    };
  }

  throw "unexpected package specifier format";
}

export function getScopedName(name: string, scope?: string): string {
  if (scope !== undefined) {
    return `${scope[0] === "@" ? "" : "@"}${scope}/${name}`;
  }
  return name;
}

export function getAllPackagesByPackageRegistry(
  lockJson: LockJson,
  registries: Set<string>
): PackagesByRegistry {
  const result: PackagesByRegistry = {};
  for (const registry of Array.from(registries)) {
    const packageInfosOfRegistries = Object.keys(lockJson[registry]).map(
      parsePackageSpecifier
    );
    result[registry] = {};
    for (const packageInfo of packageInfosOfRegistries) {
      const scopedName = getScopedName(packageInfo.name, packageInfo.scope);
      if (result[registry][scopedName] === undefined) {
        result[registry][scopedName] = {};
      }
      result[registry][scopedName][packageInfo.version] = packageInfo;
    }
  }
  return result;
}

export function findRegistryJsonPaths(
  cachePath: string,
  nonJsrPackages: PackagesByRegistry
): PathsByRegistry {
  const result: PathsByRegistry = {};
  for (const registry of Object.keys(nonJsrPackages)) {
    const path = `${cachePath}/${registry}`;
    const registryJsonPaths = Array.from(walkSync(path))
      .filter((v) => v.name === "registry.json")
      .map((v) => v.path);
    result[registry] = registryJsonPaths;
  }
  return result;
}

export function pruneRegistryJson(
  registryJson: RegistryJson,
  nonJsrPackages: PackagesByRegistry,
  registry: string
) {
  const scopedName = registryJson.name;
  const packageInfoByVersion = nonJsrPackages[registry][scopedName];
  if (!packageInfoByVersion) {
    throw `could not find key "${scopedName}" in\n${Object.keys(
      nonJsrPackages[registry]
    )}`;
  }

  const newRegistryJson: RegistryJson = {
    ...registryJson,
    "_deno.etag": "",
    "dist-tags": {},
    versions: {},
  };

  for (const version of Object.keys(packageInfoByVersion)) {
    newRegistryJson.versions[version] = registryJson.versions[version];
  }

  return newRegistryJson;
}

export function pruneRegistryJsonFiles(
  nonJsrPackages: PackagesByRegistry,
  registryJsonPathsByRegistry: PathsByRegistry
): void {
  for (const [registry, paths] of Object.entries(registryJsonPathsByRegistry)) {
    for (const path of paths) {
      const registryJson: RegistryJson = JSON.parse(
        new TextDecoder("utf-8").decode(Deno.readFileSync(path))
      );

      const newRegistryJson = pruneRegistryJson(
        registryJson,
        nonJsrPackages,
        registry
      );

      Deno.writeFileSync(
        path,
        new TextEncoder().encode(JSON.stringify(newRegistryJson))
      );
    }
  }
}

export function findMetaJsonPaths(
  vendorPath: string,
  jsrPackages: PackagesByRegistry
): PathsByRegistry {
  const result: PathsByRegistry = {};
  for (const registry of Object.keys(jsrPackages)) {
    const path = `${vendorPath}`;
    const metaJsonPaths = Array.from(walkSync(path))
      .filter((v) => v.name === "meta.json")
      .map((v) => v.path);
    result[registry] = metaJsonPaths;
  }
  return result;
}

export function pruneMetaJson(
  metaJson: MetaJson,
  jsrPackages: PackagesByRegistry,
  registry: string
): MetaJson {
  const scopedName = getScopedName(metaJson.name, metaJson.scope);
  const packageInfoByVersion = jsrPackages[registry][scopedName];
  if (!packageInfoByVersion) {
    throw `could not find key "${scopedName}" in\n${Object.keys(
      jsrPackages[registry]
    )}`;
  }
  const newMetaJson: MetaJson = {
    ...metaJson,
    latest: "",
    versions: {},
  };

  for (const version of Object.keys(packageInfoByVersion)) {
    newMetaJson.versions[version] = metaJson.versions[version];
  }
  return newMetaJson;
}

export function pruneMetaJsonFiles(
  jsrPackages: PackagesByRegistry,
  metaJsonPathsByRegistry: PathsByRegistry
): void {
  for (const [registry, paths] of Object.entries(metaJsonPathsByRegistry)) {
    for (const path of paths) {
      const metaJson: MetaJson = JSON.parse(
        new TextDecoder("utf-8").decode(Deno.readFileSync(path))
      );

      const newMetaJson = pruneMetaJson(metaJson, jsrPackages, registry);

      Deno.writeFileSync(
        path,
        new TextEncoder().encode(JSON.stringify(newMetaJson))
      );
    }
  }
}

function main() {
  const config = getConfig();
  const registries = getAllPackageRegistries(config.lockJson.specifiers);
  const packages = getAllPackagesByPackageRegistry(config.lockJson, registries);

  const jsrPackages = {
    jsr: structuredClone(packages.jsr),
  } satisfies PackagesByRegistry;
  delete packages.jsr;
  const nonJsrPackages = packages;

  const metaJsonpaths = findMetaJsonPaths(config.vendorPath, jsrPackages);
  pruneMetaJsonFiles(jsrPackages, metaJsonpaths);

  const registryJsonPaths = findRegistryJsonPaths(
    config.cachePath,
    nonJsrPackages
  );
  pruneRegistryJsonFiles(nonJsrPackages, registryJsonPaths);
}

if (import.meta.main) {
  main();
}
