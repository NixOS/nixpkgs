#!/usr/bin/env bash
set -euo pipefail

version="2.14.0"

usage() {
  printf "Usage: %s {about|update} [version]\n" "$0"
}

about() {
  echo "Documenso upstream needs some fixing before it can be built in a pure sandbox"
  echo "environment. This script regenerates the JSON patches for a version bump:"
  echo "  - download documenso version ${version} from github in a temp dir"
  echo "  - remove inngest-cli which runs a binary download script at build time"
  echo "  - upgrade turborepo because the older upstream version phones home at build time"
  echo "  - update turbo.json for the newer turborepo config"
  echo "  - fix package-lock.json metadata needed by npmDepsFetcherVersion = 2"
  echo "  - create patches from changed json files"
}

patch_sources() {
  node <<'NODE'
const fs = require('fs');

const packageJsonPath = 'package.json';
const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
delete packageJson.devDependencies['inngest-cli'];
packageJson.devDependencies.turbo = '^2.10.1';
fs.writeFileSync(packageJsonPath, `${JSON.stringify(packageJson, null, 2)}\n`);

const turboJsonPath = 'turbo.json';
let turboJson = fs.readFileSync(turboJsonPath, 'utf8');
turboJson = turboJson.replace('  "pipeline": {', '  "tasks": {');
if (!turboJson.includes('  "envMode": "loose"')) {
  turboJson = turboJson.replace('\n  ]\n}\n', '\n  ],\n  "envMode": "loose"\n}\n');
}
fs.writeFileSync(turboJsonPath, turboJson);
NODE
}

fix_playwright_lockfile_metadata() {
  local package_key="packages/app-tests/node_modules/@playwright/test"
  local playwright_version resolved integrity

  playwright_version=$(jq -r --arg key "$package_key" '.packages[$key].version // empty' package-lock.json)
  if [[ -z "$playwright_version" ]]; then
    return
  fi

  resolved=$(npm view "@playwright/test@${playwright_version}" dist.tarball)
  integrity=$(npm view "@playwright/test@${playwright_version}" dist.integrity)

  node - "$package_key" "$resolved" "$integrity" <<'NODE'
const fs = require('fs');

const [packageKey, resolved, integrity] = process.argv.slice(2);
const path = 'package-lock.json';
const lockfile = JSON.parse(fs.readFileSync(path, 'utf8'));
const packageEntry = lockfile.packages[packageKey];
const updated = {};
for (const [key, value] of Object.entries(packageEntry)) {
  updated[key] = value;
  if (key === 'version') {
    updated.resolved = resolved;
    updated.integrity = integrity;
  }
}
lockfile.packages[packageKey] = updated;
fs.writeFileSync(path, `${JSON.stringify(lockfile, null, 2)}\n`);
NODE
}

update() {
  local update_version=${1:-$version}
  local current_nixpkgs_dir temptarfile tempdir

  echo "updating documenso for nixpkgs packaging"
  current_nixpkgs_dir=${PWD}
  temptarfile="/tmp/documenso-v${update_version}.tar.gz"
  tempdir="/tmp/documenso-v${update_version}"

  if [[ ! -f "$temptarfile" ]]; then
    echo "Tarball does not exist; downloading from github."
    wget "https://github.com/documenso/documenso/archive/refs/tags/v${update_version}.tar.gz" -O "$temptarfile"
  fi

  rm -Rf "$tempdir"
  mkdir "$tempdir"
  tar -xzf "$temptarfile" -C "$tempdir" --strip-components=1
  cd "$tempdir"
  git init
  git add package-lock.json package.json turbo.json
  git commit -m "commit4diff" package-lock.json package.json turbo.json

  patch_sources
  npm install --package-lock-only --ignore-scripts --no-audit --no-fund
  fix_playwright_lockfile_metadata

  git diff --src-prefix=a/ --dst-prefix=b/ -- package-lock.json > "$current_nixpkgs_dir/package-lock.json.patch"
  git diff --src-prefix=a/ --dst-prefix=b/ -- package.json > "$current_nixpkgs_dir/package.json.patch"
  git diff --src-prefix=a/ --dst-prefix=b/ -- turbo.json > "$current_nixpkgs_dir/turbo.json.patch"
}

case "${1:-}" in
  about)
    about
    ;;
  update)
    shift
    update "${1:-}"
    ;;
  *)
    usage
    exit 1
    ;;
esac
