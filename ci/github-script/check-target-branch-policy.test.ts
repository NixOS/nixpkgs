import assert from 'node:assert/strict'
import test from 'node:test'
import { evaluateTargetBranchPolicy } from './check-target-branch-policy.ts'

type DecisionFacts = {
  base: string
  head: string
  maxRebuildCount: number
  rebuildsAllTests: boolean
  onlyChangedFile: string | null
}

type Decision =
  | 'mass-rebuild'
  | 'nixos-rebuild'
  | 'possible-mass-rebuild'
  | 'skip-development-merge'
  | 'dismiss'

const defaults: DecisionFacts = {
  base: 'master',
  head: 'topic-branch',
  maxRebuildCount: 0,
  rebuildsAllTests: false,
  onlyChangedFile: null,
}

const cases: Array<{
  name: string
  facts: Partial<DecisionFacts>
  expected: Decision
}> = [
  {
    name: 'allows fewer than 500 rebuilds on master',
    facts: { maxRebuildCount: 499 },
    expected: 'dismiss',
  },
  {
    name: 'flags 500 rebuilds on master as a possible mass rebuild',
    facts: { maxRebuildCount: 500 },
    expected: 'possible-mass-rebuild',
  },
  {
    name: 'flags 999 rebuilds on master as a possible mass rebuild',
    facts: { maxRebuildCount: 999 },
    expected: 'possible-mass-rebuild',
  },
  {
    name: 'flags 1000 rebuilds on master as a mass rebuild',
    facts: { maxRebuildCount: 1000 },
    expected: 'mass-rebuild',
  },
  {
    name: 'flags a mass rebuild on staging-nixos',
    facts: { base: 'staging-nixos', maxRebuildCount: 24_000 },
    expected: 'mass-rebuild',
  },
  {
    name: 'flags a mass rebuild on a release staging-nixos branch',
    facts: { base: 'staging-nixos-26.05', maxRebuildCount: 1000 },
    expected: 'mass-rebuild',
  },
  {
    name: 'allows mass rebuilds on staging',
    facts: { base: 'staging', maxRebuildCount: 1000 },
    expected: 'dismiss',
  },
  {
    name: 'flags a mass rebuild on a release branch',
    facts: { base: 'release-26.05', maxRebuildCount: 1000 },
    expected: 'mass-rebuild',
  },
  {
    name: 'flags NixOS test rebuilds on master',
    facts: { rebuildsAllTests: true },
    expected: 'nixos-rebuild',
  },
  {
    name: 'flags NixOS test rebuilds on a release branch',
    facts: { base: 'release-26.05', rebuildsAllTests: true },
    expected: 'nixos-rebuild',
  },
  {
    name: 'allows NixOS test rebuilds on staging-nixos',
    facts: { base: 'staging-nixos', rebuildsAllTests: true },
    expected: 'dismiss',
  },
  {
    name: 'does not flag a possible mass rebuild when staging-nixos rebuilds all NixOS tests',
    facts: {
      base: 'staging-nixos',
      maxRebuildCount: 500,
      rebuildsAllTests: true,
    },
    expected: 'dismiss',
  },
  {
    name: 'flags other possible mass rebuilds on staging-nixos',
    facts: { base: 'staging-nixos', maxRebuildCount: 500 },
    expected: 'possible-mass-rebuild',
  },
  {
    name: 'skips staging into master',
    facts: {
      head: 'staging',
      maxRebuildCount: 24_000,
    },
    expected: 'skip-development-merge',
  },
  {
    name: 'skips staging-nixos into master',
    facts: {
      head: 'staging-nixos',
      maxRebuildCount: 24_000,
    },
    expected: 'skip-development-merge',
  },
  {
    name: 'skips master into staging-nixos',
    facts: {
      base: 'staging-nixos',
      head: 'master',
      maxRebuildCount: 24_000,
    },
    expected: 'skip-development-merge',
  },
  {
    name: 'checks staging into staging-nixos',
    facts: {
      base: 'staging-nixos',
      head: 'staging',
      maxRebuildCount: 24_000,
    },
    expected: 'mass-rebuild',
  },
  {
    name: 'skips release staging-nixos into its release branch',
    facts: {
      base: 'release-26.05',
      head: 'staging-nixos-26.05',
      maxRebuildCount: 24_000,
    },
    expected: 'skip-development-merge',
  },
  {
    name: 'skips a release branch into its staging-nixos branch',
    facts: {
      base: 'staging-nixos-26.05',
      head: 'release-26.05',
      maxRebuildCount: 24_000,
    },
    expected: 'skip-development-merge',
  },
  {
    name: 'checks release staging into its staging-nixos branch',
    facts: {
      base: 'staging-nixos-26.05',
      head: 'staging-26.05',
      maxRebuildCount: 24_000,
    },
    expected: 'mass-rebuild',
  },
  {
    name: 'kernel exemption suppresses a possible mass rebuild',
    facts: {
      maxRebuildCount: 999,
      onlyChangedFile: 'pkgs/os-specific/linux/kernel/xanmod-kernels.nix',
    },
    expected: 'dismiss',
  },
  {
    name: 'kernel exemption suppresses a definite mass rebuild',
    facts: {
      maxRebuildCount: 1000,
      onlyChangedFile: 'pkgs/os-specific/linux/kernel/xanmod-kernels.nix',
    },
    expected: 'dismiss',
  },
  {
    name: 'kernel exemption suppresses a NixOS test rebuild',
    facts: {
      rebuildsAllTests: true,
      onlyChangedFile: 'pkgs/os-specific/linux/kernel/xanmod-kernels.nix',
    },
    expected: 'dismiss',
  },
  {
    name: 'Home Assistant exemption suppresses a mass rebuild',
    facts: {
      head: 'wip-home-assistant',
      maxRebuildCount: 1500,
    },
    expected: 'dismiss',
  },
  {
    name: 'does not exempt a Home Assistant update above 1500 rebuilds',
    facts: { head: 'wip-home-assistant', maxRebuildCount: 1501 },
    expected: 'mass-rebuild',
  },
  {
    name: 'Home Assistant exemption does not suppress a NixOS test rebuild',
    facts: {
      head: 'wip-home-assistant',
      maxRebuildCount: 1500,
      rebuildsAllTests: true,
    },
    expected: 'nixos-rebuild',
  },
]

for (const { name, facts, expected } of cases) {
  test(name, () => {
    assert.equal(
      evaluateTargetBranchPolicy({ ...defaults, ...facts }).decision,
      expected,
    )
  })
}
