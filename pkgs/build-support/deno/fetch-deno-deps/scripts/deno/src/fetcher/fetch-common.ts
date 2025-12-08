// TODO: jsdoc one top level doc comment per file, document what the file is, refer to the readme
// TODO: rename fetcher-default to fetcher-common
// TODO: document functions, what do they do in a few sentences
import type {
  Hash,
  HashAlgorithm,
  HashEncoding,
  HashString,
  PackageFileIn,
  PackageFileOut,
  PathString,
} from "../types.d.ts";
import { addPrefix } from "../utils.ts";

// TODO: document better
// https://github.com/denoland/deno_cache_dir/blob/0.23.0/rs_lib/src/local.rs#L802
const keepHeaders = [
  "content-type",
  "location",
  "x-deno-warning",
  "x-typescript-types",
];

export async function bytesToHash(
  byteArray: Uint8Array<ArrayBuffer>,
  cryptoSubtleAlgo: "SHA-256" | "SHA-512",
  encoding: HashEncoding,
): Promise<string> {
  const hashBuffer = await crypto.subtle.digest(cryptoSubtleAlgo, byteArray);
  const hashArray = new Uint8Array(hashBuffer);
  switch (encoding) {
    case "base64":
      return hashArray.toBase64();
    case "hex":
      return hashArray.toHex();
    default:
      throw `unexpected HashEncoding ${encoding}`;
  }
}

export async function makeOutPath(p: PackageFileIn): Promise<string> {
  const data = new TextEncoder().encode(p.url);
  const hash = await bytesToHash(data, "SHA-256", "base64");
  return hash.replaceAll("/", "_");
}

export function normalizeHashPrefix(
  hash: Hash,
): HashString {
  return hash.string.replace(`${hash.algorithm}-`, "");
}

export function toCryptoSubtleAlgo(hashAlgo: HashAlgorithm) {
  switch (hashAlgo) {
    case "sha256":
      return "SHA-256" as const;
    case "sha512":
      return "SHA-512" as const;
    default:
      throw `unexpected hashAlgo ${hashAlgo}`;
  }
}

export async function checkHash(
  filePath: PathString,
  p: PackageFileIn,
) {
  const fileData = await Deno.readFile(filePath);
  const hash = await bytesToHash(fileData, toCryptoSubtleAlgo(p.hash.algorithm), p.hash.encoding);
  const actualIntegrity = hash;
  const expectedIntegrity = normalizeHashPrefix(p.hash);

  if (actualIntegrity !== expectedIntegrity) {
    throw `integrity check failed during fetch to ${p.url}: ${actualIntegrity} !== ${expectedIntegrity}`
  }
}

export async function fetchCommon(
  outPathPrefix: PathString,
  p: PackageFileIn,
  outPath_?: PathString,
): Promise<PackageFileOut> {
  let outPath = outPath_;
  if (outPath === undefined) {
    outPath = await makeOutPath(p);
  }
  const filePath = addPrefix(outPath, outPathPrefix);
  const file = await Deno.open(filePath, {
    write: true,
    create: true,
    truncate: true,
  });
  console.log(`fetching ${p.url}`);

  const response = await fetch(p.url);
  if (!response.ok) {
    throw `fetch to ${p.url} failed`;
  }
  const headers: Record<string, string> = {};

  for (const [key, value] of response.headers.entries()) {
    const keyLower = key.toLowerCase();
    if (keepHeaders.includes(keyLower)) {
      headers[keyLower] = value;
    }
  }

  await response.body?.pipeTo(file.writable);

  await checkHash(filePath, p);

  return {
    ...p,
    outPath,
    headers,
  };
}
