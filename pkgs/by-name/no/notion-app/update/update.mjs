#!/usr/bin/env nix-shell
/*
#!nix-shell -i node --pure --packages cacert nodejs yq-go
*/
import * as assert from "node:assert/strict";
import * as child_process from "node:child_process";
import * as fsPromises from "node:fs/promises";
import * as path from "node:path";

const __dirname = import.meta.dirname;

/** @typedef {{
  version: string;
  path: `${string}.zip`;
  sha512: string;
  releaseDate: string;
  files: Array<{ url: string; sha512: string; size: number }>;
}} LiveCheckInfo */

/** @typedef {{
  version: string;
  url: string;
  hash: `sha512-${string}`;
}} Info */

const BASE_URL = "https://desktop-release.notion-static.com/";
/**
 *
 * @param {"arm64-mac.yml"} liveCheckFile
 * @returns {Promise<Info>}
 */
async function getInfo(liveCheckFile) {
  const url = /** @type {const} */ (`${BASE_URL}${liveCheckFile}`);
  const response = await fetch(url);
  assert.ok(response.ok, `Failed to fetch ${url}`);
  /** @type {LiveCheckInfo} */
  const { version, path, sha512 } = JSON.parse(
    child_process
      .execSync(`yq eval --output-format=json`, {
        input: Buffer.from(await response.arrayBuffer()),
      })
      .toString()
  );
  assert.ok(version, "version is required");
  assert.ok(path, "path is required");
  assert.ok(sha512, "sha512 is required");
  return {
    version,
    url: BASE_URL + path,
    hash: `sha512-${sha512}`,
  };
}

async function main() {
  const filePath = path.join(__dirname, "../source.json");
  /** @type {Info} */
  const oldInfo = JSON.parse(
    await fsPromises.readFile(filePath, { encoding: "utf-8" })
  );
  /** @type {Info} */
  const info = await getInfo("arm64-mac.yml");
  if (JSON.stringify(oldInfo) === JSON.stringify(info)) {
    console.log("[update] No updates found");
    return;
  }
  console.log(
    `[update] Updating Notion ${oldInfo.version} -> ${info.version}`
  );
  await fsPromises.writeFile(
    filePath,
    JSON.stringify(info, null, 2) + "\n",
    "utf-8"
  );
  console.log("[update] Updating Notion complete");
}

main();
