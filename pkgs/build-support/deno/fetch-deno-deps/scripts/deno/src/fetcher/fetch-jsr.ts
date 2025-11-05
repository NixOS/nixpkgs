import { fetchDefault, makeOutPath } from "./fetch-default.ts";
import {
  addPrefix,
  getBasePath,
  getScopedName,
  isPath,
  normalizeUnixPath,
} from "../utils.ts";
import type {
  CommonLockFormatIn,
  CommonLockFormatOut,
  MetaJson,
  PackageFileIn,
  PackageFileOut,
  PackageSpecifier,
  PathString,
  VersionMetaJson,
} from "../types.d.ts";

function makeJsrPackageFileUrl(
  inJsrRegistryUrl: string,
  packageSpecifier: PackageSpecifier,
  filePath: string,
): string {
  return `${inJsrRegistryUrl}/${
    getScopedName(packageSpecifier)
  }/${packageSpecifier.version}${filePath}`;
}

function makeMetaJsonUrl(
  inJsrRegistryUrl: string,
  packageSpecifier: PackageSpecifier,
): string {
  return `${inJsrRegistryUrl}/${getScopedName(packageSpecifier)}/meta.json`;
}

async function fetchVersionMetaJson(
  outPathPrefix: PathString,
  versionMetaJson: PackageFileIn,
): Promise<PackageFileOut> {
  return await fetchDefault(outPathPrefix, versionMetaJson);
}

function makeMetaJsonContent(packageSpecifier: PackageSpecifier): MetaJson {
  if (!packageSpecifier.scope) {
    throw `scope in jsr package required but not found in ${JSON.stringify(packageSpecifier)}`;
  }

  return {
    name: packageSpecifier.name,
    scope: packageSpecifier.scope,
    latest: packageSpecifier.version,
    versions: { [packageSpecifier.version]: {} },
  };
}

async function getFilesAndHashesUsingModuleGraph(
  outPathPrefix: PathString,
  versionMetaJson: PackageFileOut,
): Promise<Record<string, string>> {
  const parsedVersionMetaJson: VersionMetaJson = JSON.parse(
    await Deno.readTextFile(
      addPrefix(versionMetaJson.outPath, outPathPrefix),
    ),
  );
  const moduleGraph = parsedVersionMetaJson["moduleGraph1"] ||
    parsedVersionMetaJson["moduleGraph2"];
  if (!moduleGraph) {
    throw `moduleGraph required but not found in ${
      JSON.stringify(parsedVersionMetaJson)
    }`;
  }
  const exports = parsedVersionMetaJson["exports"];
  if (!exports) {
    throw `exports required but not found in ${
      JSON.stringify(parsedVersionMetaJson)
    }`;
  }

  // see `readme.md`
  const importers = Object.keys(moduleGraph);
  const exported = Object.values(exports).map((v) => v.replace(/^\.\//, "/"));
  const imported: Array<string> = [];
  Object.entries(moduleGraph).forEach(([importedFilePath, value]) => {
    const basePath = getBasePath(importedFilePath);
    value?.dependencies?.forEach((dependency) => {
      let specifier = "";
      switch (dependency.type) {
        case "static":
          specifier = dependency.specifier;
          break;
        case "dynamic":
          if (typeof dependency.argument === "string") {
            specifier = dependency.argument || "";
          } else {
            // dynamic imports can also be arrays (when multiple arguments were given
            // to the import function. we just keep the first argument
            if (!dependency.argument) {
              specifier = "";
              return;
            }
            const args = dependency.argument.filter(
              (v): v is { type: "string"; value: string } =>
                v.type === "string" &&
                typeof v.value === "string" &&
                v.value.length > 0,
            );
            if (args.length > 0) {
              specifier = args[0].value;
            } else {
              throw `unsupported moduleGraph format in ${
                JSON.stringify(versionMetaJson)
              }:\n\n${moduleGraph}`;
            }
          }
          break;
        default:
          throw `unsupported moduleGraph format in ${
            JSON.stringify(versionMetaJson)
          }:\n\n${moduleGraph}`;
      }
      // dynamic imports can also be full package specifiers, like "npm:package@version"
      // we skip those here
      if (!isPath(specifier)) {
        return;
      }
      imported.push(normalizeUnixPath(`${basePath}/${specifier}`));
    });
  });
  const all = importers.concat(exported).concat(imported);

  const set = new Set(all);
  const result: Record<string, string> = {};
  Array.from(set).forEach(
    (
      fileName,
    ) => (result[fileName] = parsedVersionMetaJson.manifest[fileName].checksum),
  );
  return result;
}

async function fetchJsrPackageFiles(
  outPathPrefix: PathString,
  inJsrRegistryUrl: string,
  versionMetaJson: PackageFileOut,
  packageSpecifier: PackageSpecifier,
): Promise<Array<PackageFileOut>> {
  let result: Array<PackageFileOut> = [];
  const resultUnresolved: Array<Promise<PackageFileOut>> = [];
  const files = await getFilesAndHashesUsingModuleGraph(
    outPathPrefix,
    versionMetaJson,
  );
  for (const [filePath, hash] of Object.entries(files)) {
    const packageFile: PackageFileIn = {
      url: makeJsrPackageFileUrl(inJsrRegistryUrl, packageSpecifier, filePath),
      hash,
      hashAlgo: "sha256",
      hashEnc: "hex",
      meta: { packageSpecifier },
    };
    resultUnresolved.push(fetchDefault(outPathPrefix, packageFile));
  }
  result = await Promise.all(resultUnresolved);
  return result;
}

export async function fetchJsr(
  outPathPrefix: PathString,
  inJsrRegistryUrl: string,
  versionMetaJson: PackageFileIn,
  packageSpecifier: PackageSpecifier,
): Promise<CommonLockFormatOut> {
  let result: Array<PackageFileOut> = [];
  result[0] = await fetchVersionMetaJson(outPathPrefix, versionMetaJson);

  result = result.concat(
    await fetchJsrPackageFiles(
      outPathPrefix,
      inJsrRegistryUrl,
      result[0],
      packageSpecifier,
    ),
  );
  return result;
}

type MetaJsonData = { content: MetaJson; packageFile: PackageFileOut };
type MetaJsonsData = Record<
  string,
  { content: MetaJson; packageFile: PackageFileOut }
>;
async function makeMetaJson(
  inJsrRegistryUrl: string,
  versionMetaJson: PackageFileIn,
  packageSpecifier: PackageSpecifier,
  metaJsons: MetaJsonsData,
): Promise<MetaJsonsData> {
  const metaJsonUrl = makeMetaJsonUrl(inJsrRegistryUrl, packageSpecifier);

  const packageFile: PackageFileOut = {
    url: metaJsonUrl,
    hash: "",
    hashAlgo: "sha256",
    hashEnc: "hex",
    outPath: "",
    meta: structuredClone(versionMetaJson.meta),
  };
  packageFile.outPath = await makeOutPath(packageFile);

  const key = getScopedName(packageSpecifier);
  const content = makeMetaJsonContent(packageSpecifier);
  // we need custom merging logic here, since there can be collisions
  // with package specifiers, when packages have the same name, but different versions.
  // that is why we are passing metaJsons to this function, so this function
  // has control over the merging details
  if (Object.hasOwn(metaJsons, key)) {
    if (
      Object.hasOwn(metaJsons[key].packageFile.meta, "otherPackageSpecifiers")
    ) {
      metaJsons[key].packageFile.meta.otherPackageSpecifiers.push(
        packageSpecifier,
      );
    } else {
      metaJsons[key].packageFile.meta.otherPackageSpecifiers = [
        packageSpecifier,
      ];
    }

    metaJsons[key].content.versions = {
      ...metaJsons[key].content.versions,
      ...content.versions,
    };
  } else {
    metaJsons[key] = {
      packageFile,
      content,
    };
  }
  return metaJsons;
}

async function writeMetaJson(
  outPathPrefix: PathString,
  metaJsonData: MetaJsonData,
) {
  const path = addPrefix(
    metaJsonData.packageFile.outPath,
    outPathPrefix,
  );

  const data = new TextEncoder().encode(
    JSON.stringify(metaJsonData.content, null, 2),
  );
  await Deno.writeFile(path, data, { create: true });
}

export async function fetchAllJsr(
  outPathPrefix: PathString,
  commonLockfileJsr: CommonLockFormatIn,
  inJsrRegistryUrl: string,
): Promise<CommonLockFormatOut> {
  let result: CommonLockFormatOut = [];
  const resultUnresolved: Array<Promise<CommonLockFormatOut>> = [];
  let metaJsons: MetaJsonsData = {};

  for (const versionMetaJson of commonLockfileJsr) {
    const packageSpecifier = versionMetaJson?.meta?.packageSpecifier;
    if (!packageSpecifier) {
      throw `packageSpecifier required but not found in ${
        JSON.stringify(versionMetaJson)
      }`;
    }

    resultUnresolved.push(
      fetchJsr(
        outPathPrefix,
        inJsrRegistryUrl,
        versionMetaJson,
        packageSpecifier,
      ),
    );

    metaJsons = await makeMetaJson(
      inJsrRegistryUrl,
      versionMetaJson,
      packageSpecifier,
      metaJsons,
    );
  }

  for (const metaJson of Object.values(metaJsons)) {
    resultUnresolved.push(Promise.resolve([metaJson.packageFile]));
    // the other files are written in fetchDefault, but we need to write the registryJsons, too
    await writeMetaJson(outPathPrefix, metaJson);
  }

  await Promise.all(resultUnresolved).then((packageFiles) => {
    result = result.concat(packageFiles.flat());
  });
  return result;
}
