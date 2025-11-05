import type {
  Hash,
  HashAlgorithm,
  HashString,
  PackageFileIn,
  PackageFileOut,
  PathString,
} from "../types.d.ts";
import { addPrefix } from "../utils.ts";

// https://github.com/denoland/deno_cache_dir/blob/0.23.0/rs_lib/src/local.rs#L802
const keepHeaders = [
  "content-type",
  "location",
  "x-deno-warning",
  "x-typescript-types",
];

export async function bytesToBase64Hash(
  byteArray: Uint8Array<ArrayBuffer>,
  cryptoSubtleAlgo: "SHA-256" | "SHA-512",
): Promise<string> {
  const hashBuffer = await crypto.subtle.digest(cryptoSubtleAlgo, byteArray);
  const hashArray = new Uint8Array(hashBuffer);
  const base64 = btoa(String.fromCharCode(...hashArray));
  return base64;
}

export async function makeOutPath(p: PackageFileIn): Promise<string> {
  const data = new TextEncoder().encode(p.url);
  const hash = await bytesToBase64Hash(data, "SHA-256");
  return hash.replaceAll("/", "_");
}

export function normalizeHashToSRI(
  hash: Hash,
): HashString {
  let result: HashString = hash.string;
  result = result.replace(`${hash.algorithm}-`, "");

  if (hash.encoding === "hex") {
    const hex = Uint8Array.fromHex(result);
    result = hex.toBase64();
  }

  result = `${hash.algorithm}-${result}`;
  return result;
}

export function toCryptoSubtleAlgo(hashAlgo: HashAlgorithm): "SHA-256" | "SHA-512" {
  switch (hashAlgo) {
    case "sha256":
      return "SHA-256";
    case "sha512":
      return "SHA-512";
    default:
      throw `unexpected hashAlgo ${hashAlgo}`;
  }
}

export async function checkHash(
  filePath: PathString,
  p: PackageFileIn,
) {
  const fileData = await Deno.readFile(filePath);
  const hash = await bytesToBase64Hash(fileData, toCryptoSubtleAlgo(p.hash.algorithm));
  const actualIntegrity = `${p.hash.algorithm}-${hash}`;
  const expectedIntegrity = normalizeHashToSRI(p.hash);

  if (actualIntegrity !== expectedIntegrity) {
    throw `integrity check failed during fetch to ${p.url}: ${actualIntegrity} !== ${expectedIntegrity}`;
  }
}

export async function fetchDefault(
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
