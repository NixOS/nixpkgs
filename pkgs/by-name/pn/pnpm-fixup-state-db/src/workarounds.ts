import { lt, satisfies } from 'semver'
import type { Metadata } from './index.js'

// pnpm v11 stored the manifest field for every dependency, including Git
// packages. pnpm 12.0.0 stopped doing this (probably a regression). This
// was fixed in 12.15.0. This means that technically v11 FODs and v12.15.0+
// FODs should be compatible, while everything in between is tainted.
// So now we need to keep doing it incorrectly by reintroducing the
// regression after the fact. We do that by deleting the `manifest` field
// for Git packages
// Again, we will drop this with an upcoming fetcherVersion 6
export function applyGitManifestWorkaround(
  fetcherVersion: number,
  pnpmVersion: string,
  data: Metadata,
) {
  if (fetcherVersion >= 6) {
    // Do not apply workaround for future fetcher versions
    return
  }
  if (lt(pnpmVersion, '12.15.0')) {
    // Do not apply workaround for pnpm versions that include the regression
    // or didn't have to fix it in the first place (i.e. pnpm v11)
    return
  }
  if (data.requiresPrepare === undefined) {
    // `requiresPrepare` seems to be the best indicator for a Git dependency
    // If it's not set, we are not looking at a Git dependency it seems?
    return
  }
  if (data.manifest === undefined) {
    return
  }
  delete data.manifest
}

export function applyGypfileWorkaround(
  fetcherVersion: number,
  pnpmVersion: string,
  data: Metadata,
) {
  if (fetcherVersion >= 6) {
    // Do not apply workaround for future fetcher versions
    return
  }
  if (!satisfies(pnpmVersion, '>=11.28.0 <12.0.0 || >=12.7.0')) {
    // See https://github.com/pnpm/pnpm/commit/d44a0978a62c3ce5f13530e41a0a9a93be0b6a54
    return
  }
  // this is either not present or a boolean. Check for undefined specifically
  if (data.manifest?.gypfile === undefined) {
    return;
  }
  delete data.manifest.gypfile
}

export function applyTarIntegrityWorkaround(
  fetcherVersion: number,
  pnpmVersion: string,
  data: Metadata,
) {
  if (fetcherVersion >= 6) {
    // Do not apply workaround for future fetcher versions
    return
  }
  if (lt(pnpmVersion, '12.15.0')) {
    // See https://github.com/pnpm/pnpm/commit/7b0d6873a68ff10862e1f0fa03c728af4bc7b56a
    return
  }
  if (data.tarIntegrity === undefined) {
    return
  }
  delete data['tarIntegrity']
}
