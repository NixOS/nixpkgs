import { fetchDefault, makeOutPath } from "./fetch-default.ts";
import { addPrefix, getScopedName } from "../utils.ts";
type Config = SingleFodFetcherConfig;

function makeRegistryJsonUrl(packageSpecifier: PackageSpecifier): string {
  // not a real url, needs to be unique per scope+name, but not unique per version
  return `${getScopedName(packageSpecifier)}/registry.json`;
}

// deno uses a subset of the json file available at `https://registry.npmjs.org/<packageName>` and calls it registry.json
// here we construct a registry.json file from the information we have. we only use the bare minimum of necessary keys and values.
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

export async function fetchNpm(
  config: Config,
  packageFile: PackageFileIn,
): Promise<Array<PackageFileOut>> {
  const result: Array<PackageFileOut> = [];
  result[0] = await fetchDefault(config, packageFile);
  return result;
}

type RegistryJsonData = { content: RegistryJson; packageFile: PackageFileOut };
type RegistryJsonsData = Record<
  string,
  { content: RegistryJson; packageFile: PackageFileOut }
>;
async function makeRegistryJson(
  versionRegistryJson: PackageFileIn,
  packageSpecifier: PackageSpecifier,
  registryJsons: RegistryJsonsData,
): Promise<RegistryJsonsData> {
  const registryJsonUrl = makeRegistryJsonUrl(packageSpecifier);

  const packageFile: PackageFileOut = {
    url: registryJsonUrl,
    hash: "",
    hashAlgo: "sha256",
    outPath: "",
    meta: structuredClone(versionRegistryJson.meta),
  };
  packageFile.outPath = await makeOutPath(packageFile);

  const key = getScopedName(packageSpecifier);
  const content = makeRegistryJsonContent(packageSpecifier);
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
  config: Config,
  registryJsonData: RegistryJsonData,
) {
  const path = addPrefix(
    registryJsonData.packageFile.outPath,
    config.outPathPrefix,
  );

  const data = new TextEncoder().encode(
    JSON.stringify(registryJsonData.content),
  );
  await Deno.writeFile(path, data, { create: true });
}

export async function fetchAllNpm(
  config: Config,
): Promise<CommonLockFormatOut> {
  let result: CommonLockFormatOut = [];
  const resultUnresolved: Array<Promise<CommonLockFormatOut>> = [];
  let registryJsons: RegistryJsonsData = {};

  for (const p of config.commonLockfileNpm) {
    const packageSpecifier = p?.meta?.packageSpecifier;
    if (!packageSpecifier) {
      throw `packageSpecifier required but not found in ${JSON.stringify(p)}`;
    }

    resultUnresolved.push(fetchNpm(config, p));

    registryJsons = await makeRegistryJson(p, packageSpecifier, registryJsons);
  }

  for (const registryJson of Object.values(registryJsons)) {
    resultUnresolved.push(Promise.resolve([registryJson.packageFile]));
    await writeRegistryJson(config, registryJson);
  }

  await Promise.all(resultUnresolved).then((packageFiles) => {
    result = result.concat(packageFiles.flat());
  });
  return result;
}
