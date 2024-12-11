import * as toml from "jsr:@std/toml@1.0.1";
import { getExistingVersion, logger, run, write } from "./common.ts";

const log = logger("librusty_v8");

export interface Architecture {
  nix: string;
  rust: string;
}
interface PrefetchResult {
  arch: Architecture;
  sha256: string;
}

const getCargoLock = async (
  owner: string,
  repo: string,
  version: string,
) =>
  fetch(`https://github.com/${owner}/${repo}/raw/${version}/Cargo.lock`)
    .then((res) => res.text())
    .then((txt) => toml.parse(txt));

const fetchArchShaTasks = (version: string, arches: Architecture[]) =>
  arches.map(
    async (arch: Architecture): Promise<PrefetchResult> => {
      log("Fetching:", arch.nix);
      const sha256 = await run("nix-prefetch", [
        `
{ fetchurl }:
fetchurl {
  url = "https://github.com/denoland/rusty_v8/releases/download/v${version}/librusty_v8_release_${arch.rust}.a.gz";
}
`,
      ]);
      log("Done:    ", arch.nix);
      return { arch, sha256 };
    },
  );

const templateDeps = (version: string, deps: PrefetchResult[]) =>
  `# auto-generated file -- DO NOT EDIT!
{ fetchLibrustyV8 }:

fetchLibrustyV8 {
  version = "${version}";
  shas = {
    x86_64-linux = "sha256-jLYl/CJp2Z+Ut6qZlh6u+CtR8KN+ToNTB+72QnVbIKM=";
    aarch64-linux = "sha256-uAkBMg6JXA+aILd8TzDtuaEdM3Axiw43Ad5tZzxNt5w=";
    x86_64-darwin = "sha256-60aR0YvQT8KyacY8J3fWKZcf9vny51VUB19NVpurS/A=";
    aarch64-darwin = "sha256-pd/I6Mclj2/r/uJTIywnolPKYzeLu1c28d/6D56vkzQ=";
${deps.map(({ arch, sha256 }) => `    ${arch.nix} = "${sha256}";`).join("\n")}
  };
}
`;

export async function updateLibrustyV8(
  filePath: string,
  owner: string,
  repo: string,
  denoVersion: string,
  arches: Architecture[],
) {
  log("Starting librusty_v8 update");
  // 0.0.0
  const cargoLockData = await getCargoLock(owner, repo, denoVersion);
  console.log(cargoLockData);
  const packageItem = cargoLockData.package.find(({ name }) => name === "v8");
  const version = packageItem.version;
  if (typeof version !== "string") {
    throw "no librusty_v8 version";
  }
  log("librusty_v8 version:", version);
  const existingVersion = await getExistingVersion(filePath);
  if (version === existingVersion) {
    log("Version already matches latest, skipping...");
    return;
  }
  const archShaResults = await Promise.all(fetchArchShaTasks(version, arches));
  await write(filePath, templateDeps(version, archShaResults));
  log("Finished deps update");
}
