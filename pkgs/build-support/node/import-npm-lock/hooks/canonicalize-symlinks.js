#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

// When installing files rewritten to the Nix store with npm
// npm writes the symlinks relative to the build directory.
//
// This makes relocating node_modules tricky when refering to the store.
// This script walks node_modules and canonicalizes symlinks.

async function canonicalize(storePrefix, root) {
  console.log(storePrefix, root)
  const entries = await fs.promises.readdir(root);
  const paths = entries.map((entry) => path.join(root, entry));

  const stats = await Promise.all(
    paths.map(async (path) => {
      return {
        path: path,
        stat: await fs.promises.lstat(path),
      };
    })
  );

  const symlinks = stats.filter((stat) => stat.stat.isSymbolicLink());
  const dirs = stats.filter((stat) => stat.stat.isDirectory());

  // Canonicalize symlinks to their real path
  await Promise.all(
    symlinks.map(async (stat) => {
      const target = await fs.promises.realpath(stat.path);
      if (target.startsWith(storePrefix)) {
        await fs.promises.unlink(stat.path);
        await fs.promises.symlink(target, stat.path);
      }
    })
  );

  // Recurse into directories
  await Promise.all(dirs.map((dir) => canonicalize(storePrefix, dir.path)));
}

async function main() {
  const args = process.argv.slice(2);
  const storePrefix = args[0];

  if (fs.existsSync("node_modules")) {
    await canonicalize(storePrefix, "node_modules");
  }
}

main();
