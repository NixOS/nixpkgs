/**
 * fetcher implementation for npm dependencies
 * see readme.md -> "NPM Packages"
 */

import { fetchCommon, makeOutPath } from "./fetch-common.ts";
import { addPrefix, getScopedName } from "../utils.ts";
import type {
  CommonLockFormatIn,
  CommonLockFormatOut,
  PackageFileIn,
  PackageFileOut,
  PackageSpecifier,
  PathString,
  RegistryJson,
} from "../types.d.ts";

/**
 * see readme.md -> "`registry.json`"
 */
function makeRegistryJsonUrl(packageSpecifier: PackageSpecifier): string {
  // not a real url, needs to be unique per scope+name, but cannot be unique per version
  return `${getScopedName(packageSpecifier)}/registry.json`;
}

/**
 * deno uses a subset of the json file available at `https://registry.npmjs.org/<packageName>` and calls it registry.json
 * here we construct a registry.json file from the information we have. we only use the bare minimum of necessary keys and values.
 * see readme.md -> "`registry.json`"
 */
function makeRegistryJsonContent(
  packageSpecifier: PackageSpecifier,
): RegistryJson {
  return {
    name: packageSpecifier.name,
    "dist-tags": {},
    "_deno.etag": "",
    versions: {
      [packageSpecifier.version]: {
        version: packageSpecifier.version,
        dist: {
          tarball: "",
        },
        bin: {},
      },
    },
  };
}

/**
 * for an npm package, we just need to fetch a single tarball
 * see readme.md -> "Package `tarball`"
 */
export async function fetchNpm(
  outPathPrefix: PathString,
  packageFile: PackageFileIn,
): Promise<Array<PackageFileOut>> {
  const result: Array<PackageFileOut> = [];
  result[0] = await fetchCommon(outPathPrefix, packageFile);
  return result;
}

type RegistryJsonData = { content: RegistryJson; packageFile: PackageFileOut };
type RegistryJsonsData = Record<
  string,
  { content: RegistryJson; packageFile: PackageFileOut }
>;

/**
 * we don't fetch the registry.json file, but construct it
 * see readme.md -> "`registry.json`"
 */
async function makeRegistryJson(
  versionRegistryJson: PackageFileIn,
  packageSpecifier: PackageSpecifier,
  registryJsons: RegistryJsonsData,
): Promise<RegistryJsonsData> {
  const registryJsonUrl = makeRegistryJsonUrl(packageSpecifier);

  const packageFile: PackageFileOut = {
    url: registryJsonUrl,
    hash: {
      string: "",
      algorithm: "sha256",
      encoding: "hex",
    },
    outPath: "",
    meta: structuredClone(versionRegistryJson.meta),
  };
  packageFile.outPath = await makeOutPath(packageFile);

  const key = getScopedName(packageSpecifier);
  const content = makeRegistryJsonContent(packageSpecifier);
  // we need custom merging logic here, since there can be collisions
  // with package specifiers, when packages have the same name, but different versions.
  // that is why we are passing registryJsons to this function, so this function
  // has control over the merging details
  if (Object.hasOwn(registryJsons, key)) {
    if (
      Object.hasOwn(
        registryJsons[key].packageFile.meta,
        "otherPackageSpecifiers",
      )
    ) {
      registryJsons[key].packageFile.meta.otherPackageSpecifiers.push(
        packageSpecifier,
      );
    } else {
      registryJsons[key].packageFile.meta.otherPackageSpecifiers = [
        packageSpecifier,
      ];
    }

    registryJsons[key].content.versions = {
      ...registryJsons[key].content.versions,
      ...content.versions,
    };
  } else {
    registryJsons[key] = {
      packageFile,
      content,
    };
  }
  return registryJsons;
}

async function writeRegistryJson(
  outPathPrefix: PathString,
  registryJsonData: RegistryJsonData,
) {
  const path = addPrefix(
    registryJsonData.packageFile.outPath,
    outPathPrefix,
  );

  const data = new TextEncoder().encode(
    JSON.stringify(registryJsonData.content, null, 2),
  );
  await Deno.writeFile(path, data, { create: true });
}

/**
 * fetch all npm dependencies in the given commonlock object
 * and construct their respective `registry.json` files
 * see readme.md -> "NPM Packages"
 */
export async function fetchAllNpm(
  outPathPrefix: PathString,
  commonLockfileNpm: CommonLockFormatIn,
): Promise<CommonLockFormatOut> {
  let result: CommonLockFormatOut = [];
  const resultUnresolved: Array<Promise<CommonLockFormatOut>> = [];
  let registryJsons: RegistryJsonsData = {};

  for (const p of commonLockfileNpm) {
    const packageSpecifier = p?.meta?.packageSpecifier;
    if (!packageSpecifier) {
      throw `packageSpecifier required but not found in ${JSON.stringify(p)}`;
    }

    resultUnresolved.push(fetchNpm(outPathPrefix, p));

    registryJsons = await makeRegistryJson(p, packageSpecifier, registryJsons);
  }

  for (const registryJson of Object.values(registryJsons)) {
    resultUnresolved.push(Promise.resolve([registryJson.packageFile]));
    // the other files are written in fetchCommon, but we need to write the registryJsons, too
    await writeRegistryJson(outPathPrefix, registryJson);
  }

  await Promise.all(resultUnresolved).then((packageFiles) => {
    result = result.concat(packageFiles.flat());
  });
  return result;
}
