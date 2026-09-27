#!/usr/bin/env nix-shell
/*
#!nix-shell -i node -p nodejs
*/
import { resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

type BranchType = 'channel' | 'development' | 'primary' | 'secondary'

const typeConfig: Record<string, BranchType[]> = {
  master: ['development', 'primary'],
  release: ['development', 'primary'],
  staging: ['development', 'secondary'],
  'staging-next': ['development', 'secondary'],
  'staging-nixos': ['development', 'secondary'],
  'haskell-updates': ['development', 'secondary'],
  nixos: ['channel'],
  nixpkgs: ['channel'],
}

// "order" ranks the development branches by how likely they are the intended base branch
// when they are an otherwise equally good fit according to ci/github-script/prepare.js.
const orderConfig: Record<string, number> = {
  master: 0,
  release: 1,
  staging: 2,
  'staging-nixos': 2,
  'haskell-updates': 3,
  'staging-next': 4,
}

type Digit = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
type Version = `${Digit}${Digit}.${Digit}${Digit}` | 'unstable'
interface SplitResult {
  prefix: string
  version: Version
  suffix?: string
}

function split(branch: string) {
  const groups = branch.match(
    /(?<prefix>.+?)(-(?<version>\d{2}\.\d{2}|unstable)(?:-(?<suffix>.*))?)?$/,
  )!.groups!
  return groups as unknown as SplitResult
}

interface BranchClassification {
  branch: string
  order: number
  stable: boolean
  type: BranchType[]
  version: Version
}

function classify(branch: string): BranchClassification {
  const { prefix, version } = split(branch)
  return {
    branch,
    order: orderConfig[prefix] ?? Infinity,
    stable: (version ?? 'unstable') !== 'unstable',
    type: typeConfig[prefix] ?? ['wip'],
    version: version ?? 'unstable',
  }
}

export { classify, split }

// If called directly via CLI, runs the following tests:
if (
  process.argv[1] &&
  fileURLToPath(import.meta.url) === resolve(process.argv[1])
) {
  console.log('split(branch)')
  function testSplit(branch: string) {
    console.log(branch, split(branch))
  }
  testSplit('master')
  testSplit('release-25.05')
  testSplit('staging')
  testSplit('staging-next')
  testSplit('staging-25.05')
  testSplit('staging-next-25.05')
  testSplit('nixpkgs-25.05-darwin')
  testSplit('nixpkgs-unstable')
  testSplit('haskell-updates')
  testSplit('backport-123-to-release-25.05')

  console.log('')

  console.log('classify(branch)')
  function testClassify(branch: string) {
    console.log(branch, classify(branch))
  }
  testClassify('master')
  testClassify('release-25.05')
  testClassify('staging')
  testClassify('staging-next')
  testClassify('staging-25.05')
  testClassify('staging-next-25.05')
  testClassify('nixpkgs-25.05-darwin')
  testClassify('nixpkgs-unstable')
  testClassify('haskell-updates')
  testClassify('backport-123-to-release-25.05')
}
