import { addPrefix, getBasePath, isPath, normalizeUnixPath } from "../utils.ts";

type Config = SingleFodFetcherConfig;

// https://github.com/denoland/deno_cache_dir/blob/0.23.0/rs_lib/src/local.rs#L802
const keepHeaders = [
  "content-type",
  "location",
  "x-deno-warning",
  "x-typescript-types",
];

export async function makeOutPath(p: PackageFileIn): Promise<string> {
  const data = new TextEncoder().encode(p.url);
  const hashBuffer = await crypto.subtle.digest("SHA-256", data);
  const hashArray = new Uint8Array(hashBuffer);
  const base64 = btoa(String.fromCharCode(...hashArray));
  return base64.replaceAll("/", "_");
}

export async function fetchDefault(
  config: Config,
  p: PackageFileIn,
  outPath_?: PathString,
): Promise<PackageFileOut> {
  let outPath = outPath_;
  if (outPath === undefined) {
    outPath = await makeOutPath(p);
  }
  const file = await Deno.open(addPrefix(outPath, config.outPathPrefix), {
    write: true,
    create: true,
    truncate: true,
  });
  console.log(`fetching ${p.url}`);
  const response = await fetch(p.url);
  if (!response.ok) {
    throw `fetch to ${p.url} failed`;
  }
  let headers: Record<string, string> | undefined = undefined;

  for (const [key, value] of response.headers.entries()) {
    const keyLower = key.toLowerCase();
    if (keepHeaders.includes(keyLower)) {
      if (headers === undefined) {
        headers = {};
      }
      headers[keyLower] = value;
    }
  }

  await response.body?.pipeTo(file.writable);
  return {
    ...p,
    outPath,
    headers,
  };
}

export async function fetchDefaultWithTypes(
  config: Config,
  p: PackageFileIn,
): Promise<Array<PackageFileOut>> {
  const result: Array<PackageFileOut> = [];
  const packageFileOut = await fetchDefault(config, p);
  result[0] = packageFileOut;

  if (
    !packageFileOut?.headers ||
    (packageFileOut?.headers &&
      !Object.keys(packageFileOut?.headers).includes("x-typescript-types"))
  ) {
    return result;
  }

  const typesUrl = packageFileOut.headers["x-typescript-types"];
  let url = "";
  if (typesUrl.startsWith("https://")) {
    url = typesUrl;
  } else if (isPath(typesUrl)) {
    const parsedUrl = new URL(packageFileOut.url);
    parsedUrl.pathname = typesUrl.replace(/^\.\//, "/");
    url = parsedUrl.toString();
  } else {
    throw `unsupported x-typescript-types url: ${typesUrl}`;
  }

  // for recursive async fetches with deduplication
  const typesCacheSet: Set<string> = new Set();

  async function parseImports(
    filePath: PathString,
    importedFromUrl: string,
  ): Promise<Array<string>> {
    const fileContent = await Deno.readTextFile(filePath);
    const fileNamesRegex = /(?:"|')[a-zA-Z0-9_\.\-\/]+\.d\.ts(?:"|')/gm;
    const importedFileNames = fileContent.match(fileNamesRegex);
    if (importedFileNames === null) {
      return [];
    }

    const importedFileUrls = importedFileNames
      ?.map((v) => v.replaceAll(/"|'/g, ""))
      .map((v) => normalizeUnixPath(`${getBasePath(importedFromUrl)}/${v}`));
    return importedFileUrls;
  }

  async function recursivelyFetchTypes(url: string) {
    if (typesCacheSet.has(url)) {
      return;
    }

    typesCacheSet.add(url);

    const typesPackageFile: PackageFileIn = {
      url,
      hash: "",
      hashAlgo: "sha256",
      meta: { from: structuredClone(p) },
    };

    const fetched = await fetchDefault(config, typesPackageFile);
    const importUrls = await parseImports(
      addPrefix(fetched.outPath, config.outPathPrefix),
      url,
    );
    result.push(fetched);

    const unresolved = importUrls.map((url) => recursivelyFetchTypes(url));
    await Promise.all(unresolved);
  }

  await recursivelyFetchTypes(url);

  // order of fetched types is not deterministic, but we need reproducible output
  result.sort((a, b) => (a.url === b.url ? 0 : a.url < b.url ? -1 : 1));
  return result;
}
