#!/usr/bin/env nix
/*
#!nix shell --ignore-environment .#cacert .#nodejs --command node
*/
// @ts-check
import assert from "node:assert/strict";
import * as fs from "node:fs";
import * as path from "node:path";
/**
 * @typedef {object} UpdateInfo
 * @property {number} timestamp Unix timestamp in seconds, example: 1763468493
 * @property {string} productVersion VSCode OSS version, example: "1.104.0"
 * @property {string} sha256hash SHA256 hash of the download file, example: "8eb01462dc4f26aba45be4992bda0b145d1ec210c63a6272578af27e59f23bef"
 * @property {string} url Download URL, example: "https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/1.11.2-6251250307170304/linux-arm/Antigravity.tar.gz", "https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/1.11.2-6251250307170304/darwin-x64/Antigravity.zip"
 */
/** @typedef {"x86_64-linux" | "aarch64-linux" | "x86_64-darwin" | "aarch64-darwin"} Platform */
/** @typedef {{ version: string; vscodeVersion: string; sources: Record<Platform, { url: string; sha256: string; }> }} Information */

let version = "";
let vscodeVersion = "";
async function getLatestInformation(/** @type {"linux-x64" | "linux-arm64" | "darwin-arm64" | "darwin"} */ targetSystem) {
  /** @type {UpdateInfo} */
  const latestInfo = await (await fetch(`https://antigravity-auto-updater-974169037036.us-central1.run.app/api/update/${targetSystem}/stable/latest`)).json();
  const newVersion = /\/antigravity\/stable\/([\d.]+)-[\d]+/.exec(latestInfo.url)?.[1] ?? ""; // Current API lack version field now, we need to parse it from the URL temporarily.
  assert(version === '' || version === newVersion, `Version mismatch: ${version}(linux-x64) != ${newVersion}(${targetSystem})`);
  version = newVersion;
  assert(vscodeVersion === '' || vscodeVersion === latestInfo.productVersion, `VSCode version mismatch: ${vscodeVersion}(linux-x64) != ${latestInfo.productVersion}(${targetSystem})`);
  vscodeVersion = latestInfo.productVersion;
  return {
    url: latestInfo.url,
    sha256: latestInfo.sha256hash,
  };
}
/** @type {Information['sources']} */
const sources = {
  "x86_64-linux": await getLatestInformation("linux-x64"),
  "aarch64-linux": await getLatestInformation("linux-arm64"),
  "x86_64-darwin": await getLatestInformation("darwin"),
  "aarch64-darwin": await getLatestInformation("darwin-arm64"),
};
/** @type {Information} */
const information = { version, vscodeVersion, sources };
fs.writeFileSync(path.join(import.meta.dirname, "./information.json"), JSON.stringify(information, null, 2) + "\n", "utf-8");
console.log(`[update] Updating Antigravity complete, version: ${version}, vscodeVersion: ${vscodeVersion}`);
