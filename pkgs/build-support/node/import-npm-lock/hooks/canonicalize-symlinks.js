#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

// When installing files rewritten to the Nix store with npm
// npm writes the symlinks relative to the build directory.
//
// This makes relocating node_modules tricky when refering to the store.
// This script walks node_modules and replaces symlinks to targets outside the
// node_modules directory with copies.

async function canonicalize(storePrefix, dir, root = path.resolve(dir)) {
  console.log(storePrefix, dir);
  const entries = await fs.promises.readdir(dir);
  const paths = entries.map((entry) => path.join(dir, entry));

  const stats = await Promise.all(
    paths.map(async (path) => {
      return { path: path, stat: await fs.promises.lstat(path) };
    }),
  );

  const symlinks = stats.filter((stat) => stat.stat.isSymbolicLink());
  const subdirs = stats.filter((stat) => stat.stat.isDirectory());

  // Replace symlinks outside the root directory with a copy of their target.
  await Promise.all(
    symlinks.map(async (stat) => {
      const target = await fs.promises.realpath(stat.path);
      // We assume that symlinks within the root can remain without issue.
      if (!target.startsWith(root + "/")) {
        await fs.promises.unlink(stat.path);
        await fs.promises.cp(target, stat.path, {
          errorOnExist: true,
          recursive: true,
        });
      }
    }),
  );

  // Recurse into directories.
  await Promise.all(
    subdirs.map((subdir) => canonicalize(storePrefix, subdir.path, root)),
  );
}

async function main() {
  const args = process.argv.slice(2);
  const storePrefix = args[0];

  if (fs.existsSync("node_modules")) {
    await canonicalize(storePrefix, "node_modules");
  }
}

main();
