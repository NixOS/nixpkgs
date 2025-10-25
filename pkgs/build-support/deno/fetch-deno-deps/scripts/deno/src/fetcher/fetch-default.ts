import type { PackageFileIn, PackageFileOut, PathString } from "../types.d.ts";
import { addPrefix } from "../utils.ts";

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
  outPathPrefix: PathString,
  p: PackageFileIn,
  outPath_?: PathString,
): Promise<PackageFileOut> {
  let outPath = outPath_;
  if (outPath === undefined) {
    outPath = await makeOutPath(p);
  }
  const file = await Deno.open(addPrefix(outPath, outPathPrefix), {
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
  return {
    ...p,
    outPath,
    headers,
  };
}
