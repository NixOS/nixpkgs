import type * as actionsCore from '@actions/core'
import type { context as actionsContext } from '@actions/github'
import type { GitHub } from '@actions/github/lib/utils'

// TODO: should this be combined with the branch checks in prepare.js?
// They do seem quite similar, but this needs to run after eval,
// and prepare.js obviously doesn't.

const { split } = require('../supportedBranches.js')
const { readFile } = require('node:fs/promises')
const { postReview, dismissReviews } = require('./reviews.js')
const {
  evaluateTargetBranchPolicy,
  getTargetBranchPolicy,
} = require('./check-target-branch-policy.ts')

const reviewKey = 'check-target-branch'

type ChangedPaths = {
  attrdiff: {
    added: string[]
    changed: string[]
    removed: string[]
  }
  attrdiffByKernel: Record<
    string,
    {
      added: string[]
      changed: string[]
      removed: string[]
    }
  >
  attrdiffByPlatform: Record<
    string,
    {
      added: string[]
      changed: string[]
      removed: string[]
    }
  >
  labels: Record<string, boolean>
  rebuildCountByKernel: Record<string, number>
  rebuildsByKernel: Record<string, string[]>
  rebuildsByPlatform: Record<string, string[]>
}

type TargetBranchReviewFacts = {
  github: InstanceType<typeof GitHub>
  context: typeof actionsContext
  core: typeof actionsCore
  dry: boolean
  base: string
  maxRebuildCount: number
}

function getStagingBranch(base: string) {
  const version = split(base).version
  return version ? `staging-${version}` : 'staging'
}

async function postMassRebuildReview(facts: TargetBranchReviewFacts) {
  const { github, context, core, dry, base, maxRebuildCount } = facts
  const desiredBranch = getStagingBranch(base)
  const body = [
    `The PR's base branch is set to \`${base}\`, but this PR causes ${maxRebuildCount} rebuilds.`,
    'It is therefore considered a mass rebuild.',
    `Please [change the base branch](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/changing-the-base-branch-of-a-pull-request) to [the right base branch for your changes](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#branch-conventions) (probably \`${desiredBranch}\`).`,
  ].join('\n')

  await postReview({
    github,
    context,
    core,
    dry,
    body,
    event: 'REQUEST_CHANGES',
    reviewKey,
  })
}

async function postNixosRebuildReview(facts: TargetBranchReviewFacts) {
  const { github, context, core, dry, base, maxRebuildCount } = facts
  let branchText: string
  if (base === 'master' && maxRebuildCount >= 500) {
    branchText = '(probably either `staging-nixos` or `staging`)'
  } else if (base === 'master') {
    branchText = '(probably `staging-nixos`)'
  } else if (maxRebuildCount >= 500) {
    branchText = `(probably either \`staging-nixos-${split(base).version}\` or \`staging-${split(base).version}\`)`
  } else {
    branchText = `(probably \`staging-nixos-${split(base).version}\`)`
  }
  const body = [
    `The PR's base branch is set to \`${base}\`, but this PR rebuilds all NixOS tests.`,
    base === 'master' && maxRebuildCount >= 500
      ? `Since this PR also causes ${maxRebuildCount} rebuilds, it may also be considered a mass rebuild.`
      : '',
    `Please [change the base branch](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/changing-the-base-branch-of-a-pull-request) to [the right base branch for your changes](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#branch-conventions) ${branchText}.`,
  ].join('\n')

  await postReview({
    github,
    context,
    core,
    dry,
    body,
    event: 'REQUEST_CHANGES',
    reviewKey,
  })
}

async function postPossibleMassRebuildReview(facts: TargetBranchReviewFacts) {
  const { github, context, core, dry, base, maxRebuildCount } = facts
  const stagingBranch = getStagingBranch(base)
  const body = [
    `The PR's base branch is set to \`${base}\`, and this PR causes ${maxRebuildCount} rebuilds.`,
    `Please consider whether this PR causes a mass rebuild according to [our conventions](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#branch-conventions).`,
    `If it does cause a mass rebuild, please [change the base branch](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/changing-the-base-branch-of-a-pull-request) to [the right base branch for your changes](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#branch-conventions) (probably \`${stagingBranch}\`).`,
    `If it does not cause a mass rebuild, this message can be ignored.`,
  ].join('\n')

  await postReview({
    github,
    context,
    core,
    dry,
    body,
    event: 'REQUEST_CHANGES',
    reviewKey,
  })
}

async function checkTargetBranch({
  github,
  context,
  core,
  dry,
}: {
  github: InstanceType<typeof GitHub>
  context: typeof actionsContext
  core: typeof actionsCore
  dry: boolean
}) {
  const changed: ChangedPaths = JSON.parse(
    await readFile('comparison/changed-paths.json', 'utf-8'),
  )
  const pull_number = context.payload.pull_request?.number
  if (!pull_number) {
    core.warning(
      'Skipping checkTargetBranch: no pull_request number (is this being run as part of a merge group?)',
    )
    return
  }
  const prInfo = (
    await github.rest.pulls.get({
      ...context.repo,
      pull_number,
    })
  ).data
  const base = prInfo.base.ref
  const head = prInfo.head.ref
  const { shouldCheckMassRebuild } = getTargetBranchPolicy({ base, head })

  const maxRebuildCount = Math.max(
    ...Object.values(changed.rebuildCountByKernel),
  )
  const rebuildsAllTests =
    changed.attrdiff.changed.includes('nixosTests.simple-container') ||
    changed.attrdiff.changed.includes('nixosTests.simple-vm')

  let onlyChangedFile: string | null = null
  if (shouldCheckMassRebuild && prInfo.changed_files === 1) {
    const changedFiles = (
      await github.rest.pulls.listFiles({
        ...context.repo,
        pull_number,
      })
    ).data
    onlyChangedFile =
      changedFiles.length === 1 ? changedFiles[0].filename : null
  }

  const {
    decision,
    details: { isExemptKernelUpdate, isExemptHomeAssistantUpdate },
  } = evaluateTargetBranchPolicy({
    base,
    head,
    maxRebuildCount,
    rebuildsAllTests,
    onlyChangedFile,
  })

  core.info(
    [
      `checkTargetBranch: this PR:`,
      `  * causes ${maxRebuildCount} rebuilds`,
      `  * ${rebuildsAllTests ? 'rebuilds' : 'does not rebuild'} all NixOS tests`,
      `  * ${isExemptKernelUpdate ? 'is' : 'is not'} an exempt kernel update`,
      `  * ${isExemptHomeAssistantUpdate ? 'is' : 'is not'} an exempt home-assistant update`,
    ].join('\n'),
  )

  const reviewFacts: TargetBranchReviewFacts = {
    github,
    context,
    core,
    dry,
    base,
    maxRebuildCount,
  }

  if (decision === 'mass-rebuild') {
    await postMassRebuildReview(reviewFacts)
    return
  }

  if (decision === 'nixos-rebuild') {
    await postNixosRebuildReview(reviewFacts)
    return
  }

  if (decision === 'possible-mass-rebuild') {
    await postPossibleMassRebuildReview(reviewFacts)
    return
  }

  if (decision === 'skip-development-merge') {
    core.info(
      `Skipping checkTargetBranch: PR merges the development branch ${head} into ${base}`,
    )
  } else {
    core.info('checkTargetBranch: this PR is against an appropriate branch.')
  }

  await dismissReviews({
    github,
    context,
    core,
    dry,
    reviewKey,
  })
}

module.exports = checkTargetBranch
