/// @ts-check

// TODO: should this be combined with the branch checks in prepare.js?
// They do seem quite similar, but this needs to run after eval,
// and prepare.js obviously doesn't.

const { classify, split } = require('../supportedBranches.js')
const { readFile } = require('node:fs/promises')
const { postReview, dismissReviews } = require('./reviews.js')

const reviewKey = 'check-target-branch'
/**
 * @param {{
 *  github: InstanceType<import('@actions/github/lib/utils').GitHub>,
 *  context: import('@actions/github/lib/context').Context
 *  core: import('@actions/core')
 *  dry: boolean
 * }} CheckTargetBranchProps
 */
async function checkTargetBranch({ github, context, core, dry }) {
  /**
   * @type {{
   *  attrdiff: {
   *   added: string[],
   *   changed: string[],
   *   removed: string[],
   *  },
   *  labels: Record<string, boolean>,
   *  rebuildCountByKernel: Record<string, number>,
   *  rebuildsByKernel: Record<string, string[]>,
   *  rebuildsByPlatform: Record<string, string[]>,
   * }}
   */
  const changed = JSON.parse(
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
  const baseClassification = classify(base)
  const headClassification = classify(head)

  // Don't run on, e.g., staging-nixos to master merges.
  if (headClassification.type.includes('development')) {
    core.info(
      `Skipping checkTargetBranch: PR is from a development branch (${head})`,
    )

    await dismissReviews({
      github,
      context,
      core,
      dry,
      reviewKey,
    })

    return
  }
  // Don't run on PRs against staging branches, wip branches, haskell-updates, etc.
  if (!baseClassification.type.includes('primary')) {
    core.info(
      `Skipping checkTargetBranch: PR is against a non-primary base branch (${base})`,
    )

    await dismissReviews({
      github,
      context,
      core,
      dry,
      reviewKey,
    })

    return
  }

  const maxRebuildCount = Math.max(
    ...Object.values(changed.rebuildCountByKernel),
  )
  const rebuildsAllTests =
    changed.attrdiff.changed.includes('nixosTests.simple')

  // https://github.com/NixOS/nixpkgs/pull/481205#issuecomment-3790123921
  // These should go to staging-nixos instead of master,
  // but release-xx.xx (not staging-xx.xx) when backported
  let isExemptKernelUpdate = false
  if (prInfo.changed_files === 1 && base.startsWith('release-')) {
    const changedFiles = (
      await github.rest.pulls.listFiles({
        ...context.repo,
        pull_number,
      })
    ).data
    isExemptKernelUpdate =
      changedFiles.length === 1 &&
      changedFiles[0].filename ===
        'pkgs/os-specific/linux/kernel/kernels-org.json'
  }

  // https://github.com/NixOS/nixpkgs/pull/483194#issuecomment-3793393218
  const isExemptHomeAssistantUpdate =
    maxRebuildCount <= 1500 && head === 'wip-home-assistant'

  core.info(
    [
      `checkTargetBranch: this PR:`,
      `  * causes ${maxRebuildCount} rebuilds`,
      `  * ${rebuildsAllTests ? 'rebuilds' : 'does not rebuild'} all NixOS tests`,
      `  * ${isExemptKernelUpdate ? 'is' : 'is not'} an exempt kernel update`,
      `  * ${isExemptHomeAssistantUpdate ? 'is' : 'is not'} an exempt home-assistant update`,
    ].join('\n'),
  )

  if (
    maxRebuildCount >= 1000 &&
    !isExemptHomeAssistantUpdate &&
    !isExemptKernelUpdate
  ) {
    const desiredBranch =
      base === 'master' ? 'staging' : `staging-${split(base).version}`
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
      event: 'COMMENT',
      reviewKey,
    })

    throw new Error('This PR is against the wrong branch.')
  } else if (rebuildsAllTests && !isExemptKernelUpdate) {
    let branchText
    if (base === 'master' && maxRebuildCount >= 500) {
      branchText = '(probably either `staging-nixos` or `staging`)'
    } else if (base === 'master') {
      branchText = '(probably `staging-nixos`)'
    } else {
      branchText = `(probably \`staging-${split(base).version}\`)`
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
      event: 'COMMENT',
      reviewKey,
    })

    throw new Error('This PR is against the wrong branch.')
  } else if (
    maxRebuildCount >= 500 &&
    !isExemptKernelUpdate &&
    !isExemptHomeAssistantUpdate
  ) {
    const stagingBranch =
      base === 'master' ? 'staging' : `staging-${split(base).version}`
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
      event: 'COMMENT',
      reviewKey,
    })
  } else {
    core.info('checkTargetBranch: this PR is against an appropriate branch.')

    await dismissReviews({
      github,
      context,
      core,
      dry,
      reviewKey,
    })
  }
}

module.exports = checkTargetBranch
