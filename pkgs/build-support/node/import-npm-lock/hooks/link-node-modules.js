#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

const node_modules = process.env.NODE_PATH || "node_modules"

async function asyncFilter(arr, pred) {
  const filtered = [];
  for (const elem of arr) {
    if (await pred(elem)) {
      filtered.push(elem);
    }
  }
  return filtered;
}

async function isSymlinkWithTargetPathPrefix(path, targetPathPrefix) {
  const stat = await fs.promises.lstat(path);
  if (!stat.isSymbolicLink()) {
    return false;
  }
  const targetPath = await fs.promises.readlink(path);
  return targetPath.startsWith(targetPathPrefix);
}

// Get a list of all _unmanaged_ files in node_modules.
// This means every file in node_modules that is _not_ a symlink to the Nix store.
async function getUnmanagedFiles(storePrefix, dir, files) {
  return await asyncFilter(files, async (file) => {
    const filePath = path.join(dir, file);
    return !await isSymlinkWithTargetPathPrefix(filePath, storePrefix);
  });
}

async function replaceFile(targetPath, createFile) {
  const tmpPath = `${targetPath}.tmp.${process.pid}`
  await createFile(tmpPath);
  await fs.promises.rename(tmpPath, targetPath);
}

async function replaceSymlink(targetPath, linkPath, createSymlink) {
  // No need to replace the symlink if it already points to the right target
  try {
    if (await fs.promises.readlink(linkPath) === targetPath) {
      return;
    }
  } catch (err) {
    // If the symlink doesn't already exist, keep going. If we get a
    // different error trying to read it, fail.
    if (err.code !== "ENOENT") {
      throw err;
    }
  }
  // Replace the link, if it exists, atomically.
  await replaceFile(linkPath, (tmpPath) => createSymlink(targetPath, tmpPath));
}

async function ensureSymlink(targetPath, linkPath) {
  replaceSymlink(targetPath, linkPath, fs.promises.symlink);
}

// Works like `cp --no-dereference`
async function copySymlink(source, target) {
  const sourceTarget = await fs.promises.readlink(source);
  await fs.promises.symlink(sourceTarget, target);
}

async function ensureCopySymlink(targetPath, linkPath) {
  await replaceSymlink(targetPath, linkPath, copySymlink);
}

async function relinkModulesDir(sourceDir, targetDir, storePrefix, workspaceLinkTargetPathPrefix = "../") {
  // Ensure directory exists
  try {
    await fs.promises.mkdir(targetDir);
  } catch (err) {
    if (err.code !== "EEXIST") {
      throw err;
    }
  }

  const files = await fs.promises.readdir(targetDir);

  // Get deny list of files that we don't manage.
  // We do manage nix store symlinks, but not other files.
  // For example: If a .vite was present in both our
  // source node_modules and the non-store node_modules we don't want to overwrite
  // the non-store one.
  const unmanaged = await getUnmanagedFiles(storePrefix, targetDir, files);
  const managed = new Set(files.filter((file) => ! unmanaged.includes(file)));

  const sourceFiles = await fs.promises.readdir(sourceDir);
  await Promise.all(
    sourceFiles.map(async (file) => {
      const sourcePath = path.join(sourceDir, file);
      const targetPath = path.join(targetDir, file);
      // Is this a scoped directory?
      if (file[0] === "@") {
        // If so, walk it because it might also contain symlinks to workspace source directories (see below)
        await relinkModulesDir(sourcePath, targetPath, storePrefix, path.join(workspaceLinkTargetPathPrefix, "../"));
      } else {
        // Is this a relative symlink, potentially pointing to a workspace source directory?
        if (await isSymlinkWithTargetPathPrefix(sourcePath, workspaceLinkTargetPathPrefix)) {
          // If so, copy it instead of linking to it so that it points to the local workspace source
          // directory rather than the one in the nix store. This allows working on the workspace
          // code without having to rebuild node_modules for every change.
          await ensureCopySymlink(sourcePath, targetPath);
        } else {
          // Skip file if it's not a symlink to a store path
          if (unmanaged.includes(file)) {
            console.log(`'${targetPath}' exists, cowardly refusing to link.`);
            return;
          }

          // Otherwise, link it
          await ensureSymlink(sourcePath, targetPath);

          // Don't unlink this file, we just wrote it.
          managed.delete(file);
        }
      }
    })
  );

  // Clean up store symlinks not included in this generation of node_modules
  await Promise.all(
    Array.from(managed).map((file) =>
      fs.promises.unlink(path.join(targetDir, file)),
    )
  );
}

async function main() {
  const args = process.argv.slice(2);
  const storePrefix = args[0];
  const sourceModules = args[1];
  await relinkModulesDir(sourceModules, node_modules, storePrefix);
}

main();
