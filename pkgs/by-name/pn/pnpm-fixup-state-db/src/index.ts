#!/usr/bin/env node
import { packForStorage, StoreIndex } from '@pnpm/store.index'
import {
  applyGitManifestWorkaround,
  applyGypfileWorkaround,
  applyTarIntegrityWorkaround,
} from './workarounds.js'

export interface FileMetadata {
  checkedAt: number
}

export interface Manifest {
  gypfile?: boolean
}

export interface Metadata {
  files: Map<string, FileMetadata>
  manifest?: Manifest
  requiresPrepare?: boolean
  tarIntegrity?: string
}

function requireEnv(name: string) {
  const value = process.env[name]
  if (!value) {
    throw new Error(`Environment variable ${name} is required.`)
  }
  return value
}

function validateMetadata(data: unknown): data is Metadata {
  return (data as Metadata).files instanceof Map
}

// from https://github.com/pnpm/pnpm/blob/52ee08aad4fcc0dfb92bc35cc5aaf3d07f8f3246/worker/src/start.ts#L235
function packToShared(data: unknown): Uint8Array {
  const packed = packForStorage(data)
  const shared = new SharedArrayBuffer(packed.byteLength)
  const view = new Uint8Array(shared)
  view.set(packed)
  return view
}

const main = () => {
  const pnpmVersion = requireEnv('NIXPKGS_PNPM_VERSION')
  const fetcherVersion = parseInt(
    requireEnv('NIXPKGS_PNPM_FETCHER_VERSION'),
    10,
  )

  const storePath = process.argv[2]
  const index = new StoreIndex(storePath)

  const newEntries = [] as Parameters<StoreIndex['setRawMany']>[0]

  for (const [key, data] of index.entries()) {
    console.debug(`Mapping ${key}...`)
    if (!validateMetadata(data)) {
      console.debug(`Data of ${key}:`, data)
      throw new Error(`Failed to read data for ${key}`)
    }
    const newFiles = new Map<string, FileMetadata>()
    for (const [path, metadata] of data.files.entries()) {
      newFiles.set(path, {
        ...metadata,
        checkedAt: 0,
      })
    }
    applyGitManifestWorkaround(fetcherVersion, pnpmVersion, data)
    applyGypfileWorkaround(fetcherVersion, pnpmVersion, data)
    applyTarIntegrityWorkaround(fetcherVersion, pnpmVersion, data)
    newEntries.push({
      key,
      buffer: packToShared({
        ...data,
        files: newFiles,
      } as Metadata),
    })
  }

  // As pnpm is highly parallelized, the order of the data in the database is random. Therefore, we need to sort our changed data and replace all data in the database
  const sortedEntries = newEntries.sort((a, b) => (a.key > b.key ? 1 : -1))

  // Delete all entries and add them in a deterministic order
  index.deleteMany(sortedEntries.map((m) => m.key))
  index.setRawMany(sortedEntries)
}

main()
