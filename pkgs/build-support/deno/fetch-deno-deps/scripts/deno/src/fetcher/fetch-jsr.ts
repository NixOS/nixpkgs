import { fetchDefault, makeOutPath } from "./fetch-default.ts";
import {
  addPrefix,
  getBasePath,
  getScopedName,
  isPath,
  normalizeUnixPath,
} from "../utils.ts";

type Config = SingleFodFetcherConfig;
function makeJsrPackageFileUrl(
  packageSpecifier: PackageSpecifier,
  filePath: string,
): string {
  return `https://jsr.io/${getScopedName(packageSpecifier)}/${packageSpecifier.version}${filePath}`;
}

function makeMetaJsonUrl(packageSpecifier: PackageSpecifier): string {
  return `https://jsr.io/${getScopedName(packageSpecifier)}/meta.json`;
}

async function fetchVersionMetaJson(
  config: Config,
  versionMetaJson: PackageFileIn,
): Promise<PackageFileOut> {
  return await fetchDefault(config, versionMetaJson);
}

function makeMetaJsonContent(packageSpecifier: PackageSpecifier): MetaJson {
  if (!packageSpecifier.scope) {
    throw `jsr package has no scope ${JSON.stringify(packageSpecifier)}`;
  }

  return {
    name: packageSpecifier.name,
    scope: packageSpecifier.scope,
    latest: packageSpecifier.version,
    versions: { [packageSpecifier.version]: {} },
  };
}

async function getFilesAndHashesUsingModuleGraph(
  config: Config,
  versionMetaJson: PackageFileOut,
): Promise<Record<string, string>> {
  const parsedVersionMetaJson: VersionMetaJson = JSON.parse(
    await Deno.readTextFile(
      addPrefix(versionMetaJson.outPath, config.outPathPrefix),
    ),
  );
  const moduleGraph =
    parsedVersionMetaJson["moduleGraph1"] ||
    parsedVersionMetaJson["moduleGraph2"];
  if (!moduleGraph) {
    throw `moduleGraph required but not found in ${JSON.stringify(parsedVersionMetaJson)}`;
  }
  const exports = parsedVersionMetaJson["exports"];
  if (!exports) {
    throw `exports required but not found in ${JSON.stringify(parsedVersionMetaJson)}`;
  }

  const importers = Object.keys(moduleGraph);
  const exporters = Object.values(exports).map((v) => v.replace(/^\.\//, "/"));
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
            if (!dependency.argument) {
              specifier = ""
              return
            }
            const args = dependency.argument.filter(
              (v): v is { type: "string"; value: string } =>
                v.type === "string" &&
                typeof v.value === "string" &&
                v.value.length > 0,
            );
            if (args.length > 0){
              specifier = args[0].value;
            } else {
              throw `unsupported moduleGraph format in ${JSON.stringify(versionMetaJson)}:\n\n${moduleGraph}`;
            }
          }
          break;
        default:
          throw `unsupported moduleGraph format in ${JSON.stringify(versionMetaJson)}:\n\n${moduleGraph}`;
      }
      if (!isPath(specifier)) {
        return;
      }
      imported.push(normalizeUnixPath(`${basePath}/${specifier}`));
    });
  });
  const all = importers.concat(exporters).concat(imported);

  const set = new Set(all);
  const result: Record<string, string> = {};
  Array.from(set).forEach(
    (fileName) =>
      (result[fileName] = parsedVersionMetaJson.manifest[fileName].checksum),
  );
  return result;
}

async function fetchJsrPackageFiles(
  config: Config,
  versionMetaJson: PackageFileOut,
  packageSpecifier: PackageSpecifier,
): Promise<Array<PackageFileOut>> {
  let result: Array<PackageFileOut> = [];
  const resultUnresolved: Array<Promise<PackageFileOut>> = [];
  const files = await getFilesAndHashesUsingModuleGraph(
    config,
    versionMetaJson,
  );
  for (const [filePath, hash] of Object.entries(files)) {
    const packageFile: PackageFileIn = {
      url: makeJsrPackageFileUrl(packageSpecifier, filePath),
      hash,
      hashAlgo: "sha256",
      meta: { packageSpecifier },
    };
    resultUnresolved.push(fetchDefault(config, packageFile));
  }
  result = await Promise.all(resultUnresolved);
  return result;
}

export async function fetchJsr(
  config: Config,
  versionMetaJson: PackageFileIn,
  packageSpecifier: PackageSpecifier,
): Promise<CommonLockFormatOut> {
  let result: Array<PackageFileOut> = [];
  result[0] = await fetchVersionMetaJson(config, versionMetaJson);

  result = result.concat(
    await fetchJsrPackageFiles(config, result[0], packageSpecifier),
  );
  return result;
}

type MetaJsonData = { content: MetaJson; packageFile: PackageFileOut };
type MetaJsonsData = Record<
  string,
  { content: MetaJson; packageFile: PackageFileOut }
>;
async function makeMetaJson(
  versionMetaJson: PackageFileIn,
  packageSpecifier: PackageSpecifier,
  metaJsons: MetaJsonsData,
): Promise<MetaJsonsData> {
  const metaJsonUrl = makeMetaJsonUrl(packageSpecifier);

  const packageFile: PackageFileOut = {
    url: metaJsonUrl,
    hash: "",
    hashAlgo: "sha256",
    outPath: "",
    meta: structuredClone(versionMetaJson.meta),
  };
  packageFile.outPath = await makeOutPath(packageFile);

  const key = getScopedName(packageSpecifier);
  const content = makeMetaJsonContent(packageSpecifier);
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

async function writeMetaJson(config: Config, metaJsonData: MetaJsonData) {
  const path = addPrefix(
    metaJsonData.packageFile.outPath,
    config.outPathPrefix,
  );

  const data = new TextEncoder().encode(JSON.stringify(metaJsonData.content));
  await Deno.writeFile(path, data, { create: true });
}

export async function fetchAllJsr(
  config: Config,
): Promise<CommonLockFormatOut> {
  let result: CommonLockFormatOut = [];
  const resultUnresolved: Array<Promise<CommonLockFormatOut>> = [];
  let metaJsons: MetaJsonsData = {};

  for (const versionMetaJson of config.commonLockfileJsr) {
    const packageSpecifier = versionMetaJson?.meta?.packageSpecifier;
    if (!packageSpecifier) {
      throw `packageSpecifier required but not found in ${JSON.stringify(versionMetaJson)}`;
    }

    resultUnresolved.push(fetchJsr(config, versionMetaJson, packageSpecifier));

    metaJsons = await makeMetaJson(
      versionMetaJson,
      packageSpecifier,
      metaJsons,
    );
  }

  for (const metaJson of Object.values(metaJsons)) {
    resultUnresolved.push(Promise.resolve([metaJson.packageFile]));
    await writeMetaJson(config, metaJson);
  }

  await Promise.all(resultUnresolved).then((packageFiles) => {
    result = result.concat(packageFiles.flat());
  });
  return result;
}
