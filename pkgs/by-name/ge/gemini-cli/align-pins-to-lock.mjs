// From https://github.com/numtide/llm-agents.nix/blob/f2b28ba3d/packages/gemini-cli/align-pins-to-lock.mjs (MIT)
// Align exact dependency pins in workspace package.json files to the versions
// that package-lock.json actually resolves.
//
// gemini-cli's committed lockfile drifts from its workspace package.json files:
// some packages pin an exact version (e.g. "tar": "7.5.8") that differs from
// the version the lockfile installs (7.5.11). buildNpmPackage builds the
// offline npm cache from the lockfile, so `npm ci` fails with ETARGET when a
// pin cannot be satisfied. Rewriting the pins to the resolved versions keeps
// package.json and the lockfile consistent without touching the cache.
import { readFileSync, writeFileSync } from "node:fs";

const lock = JSON.parse(readFileSync("package-lock.json", "utf8"));
const pkgs = lock.packages;
const exact = /^\d+\.\d+\.\d+$/;
const sections = ["dependencies", "devDependencies", "optionalDependencies"];

const resolve = (dir, name) =>
  pkgs[`${dir}/node_modules/${name}`]?.version ??
  pkgs[`node_modules/${name}`]?.version;

for (const [dir, entry] of Object.entries(pkgs)) {
  if (dir.includes("node_modules")) continue; // workspace roots only
  const file = dir ? `${dir}/package.json` : "package.json";
  let json = JSON.parse(readFileSync(file, "utf8"));
  let changed = false;
  for (const section of sections) {
    const deps = json[section];
    if (!deps) continue;
    for (const [name, spec] of Object.entries(deps)) {
      if (!exact.test(spec)) continue;
      const resolved = resolve(dir, name);
      if (resolved && resolved !== spec) {
        deps[name] = resolved;
        changed = true;
        console.log(`align ${file}: ${name} ${spec} -> ${resolved}`);
      }
    }
  }
  if (changed) writeFileSync(file, JSON.stringify(json, null, 2) + "\n");
}
