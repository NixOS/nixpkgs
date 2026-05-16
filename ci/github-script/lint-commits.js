// @ts-check
const { classify } = require('../supportedBranches.js')
const { getCommitDetailsForPR } = require('./get-pr-commit-details.js')

/** @typedef {import('./get-pr-commit-details.js').Commit} Commit */

/**
 * @param {{
 *  github: InstanceType<import('@actions/github/lib/utils').GitHub>,
 *  context: typeof import('@actions/github').context,
 *  core: import('@actions/core'),
 *  repoPath?: string,
 * }} LintCommitsProps
 */
async function lintCommits({ github, context, core, repoPath }) {
  // This check should only be run when we have the pull_request context.
  const pull_number = context.payload.pull_request?.number
  if (!pull_number) {
    core.info('This is not a pull request. Skipping checks.')
    return
  }

  const pr = (
    await github.rest.pulls.get({
      ...context.repo,
      pull_number,
    })
  ).data

  const baseBranchType = classify(
    pr.base.ref.replace(/^refs\/heads\//, ''),
  ).type
  const headBranchType = classify(
    pr.head.ref.replace(/^refs\/heads\//, ''),
  ).type

  if (
    baseBranchType.includes('development') &&
    headBranchType.includes('development') &&
    pr.base.repo.id === pr.head.repo?.id
  ) {
    // This matches, for example, PRs from NixOS:staging-next to NixOS:master, or vice versa.
    // Ignore them: we should only care about PRs introducing *new* commits.
    // We still want to run on PRs from, e.g., Someone:master to NixOS:master, though.
    core.info(
      'This PR is from one development branch to another. Skipping checks.',
    )
    return
  }

  const commits = await getCommitDetailsForPR({ core, pr, repoPath })

  await checkCommitMessages({ commits, core })
  await checkCommitMetadata({ commits, core })
}

/**
 * @param {{
 *  commits: Commit[],
 *  core: import('@actions/core'),
 * }} CheckCommitMessagesProps
 */
async function checkCommitMessages({ commits, core }) {
  const failures = new Set()

  const conventionalCommitTypes = [
    'build',
    'chore',
    'ci',
    'doc',
    'docs',
    'feat',
    'feature',
    'fix',
    'perf',
    'refactor',
    'style',
    'test',
  ]

  /**
   * @param {string[]} types e.g. ["fix", "feat"]
   * @param {string?} sha commit hash
   */
  function makeConventionalCommitRegex(types, sha = null) {
    core.info(
      `${
        sha
          ? `Conventional commit types for ${sha?.slice(0, 16)}`
          : 'Default conventional commit types'
      }: ${JSON.stringify(types)}`,
    )

    return new RegExp(`^(${types.join('|')})!?(\\(.*\\))?!?:`)
  }

  // Optimize for the common case that we don't have path segments with the
  // same name as a conventional commit type.
  const fullConventionalCommitRegex = makeConventionalCommitRegex(
    conventionalCommitTypes,
  )

  for (const commit of commits) {
    const logMsgStart = `Commit ${commit.sha}'s message's subject ("${commit.subject}")`

    // If we have a commit `perf: ...`, and we touch a file containing the path
    // segment "perf", we don't want to flag this.
    const filteredTypes = conventionalCommitTypes.filter(
      (type) => !commit.changedPathSegments.has(type),
    )
    const conventionalCommitRegex =
      filteredTypes.length === conventionalCommitTypes.length
        ? fullConventionalCommitRegex
        : makeConventionalCommitRegex(filteredTypes, commit.sha)

    if (!commit.subject.includes(': ')) {
      core.error(
        `${logMsgStart} was detected as not meeting our guidelines because ` +
          'it does not contain a colon followed by a whitespace. ' +
          'There are likely other issues as well.',
      )
      failures.add(commit.sha)
    }

    if (commit.subject.endsWith('.')) {
      core.error(
        `${logMsgStart} was detected as not meeting our guidelines because ` +
          'it ends in a period. There may be other issues as well.',
      )
      failures.add(commit.sha)
    }

    const fixups = ['amend!', 'fixup!', 'squash!']
    if (fixups.some((s) => commit.subject.startsWith(s))) {
      core.error(
        `${logMsgStart} was detected as not meeting our guidelines because ` +
          `it begins with "${fixups.find((s) => commit.subject.startsWith(s))}". ` +
          'Did you forget to run `git rebase -i --autosquash`?',
      )
      failures.add(commit.sha)
    }

    if (conventionalCommitRegex.test(commit.subject)) {
      core.error(
        `${logMsgStart} was detected as not meeting our guidelines because ` +
          'it seems to use conventional commit (conventionalcommits.org) ' +
          'formatting. Nixpkgs has its own, different, commit message ' +
          'formatting standards.',
      )
      failures.add(commit.sha)
    }

    if (!failures.has(commit.sha)) {
      core.info(`${logMsgStart} passed our automated checks!`)
    }
  }

  if (failures.size !== 0) {
    core.error(
      'Please review the guidelines at ' +
        '<https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#commit-conventions>, ' +
        'as well as the applicable area-specific guidelines linked there.',
    )
    core.setFailed('Committers: merging is discouraged.')
  }
}

/**
 * @param {{
 *  commits: Commit[],
 *  core: import('@actions/core'),
 * }} CheckGitFieldsProps
 */
async function checkCommitMetadata({ commits, core }) {
  const failures = new Set()

  /** @type {(s: string) => boolean} */
  const isEmail = (s) => /^.+@.*$/.test(s)

  for (const commit of commits) {
    if (!commit.author.name) {
      core.error(`Commit ${commit.sha} author's name field is missing`)
      failures.add(commit.sha)
    }

    if (!commit.author.email || !isEmail(commit.author.email)) {
      core.error(
        `Commit ${commit.sha} author's email field is missing or invalid`,
      )
      failures.add(commit.sha)
    }

    if (!commit.committer.name) {
      core.error(`Commit ${commit.sha} committer's name field is missing`)
      failures.add(commit.sha)
    }

    if (!commit.committer.email || !isEmail(commit.committer.email)) {
      core.error(
        `Commit ${commit.sha} committer's email field is missing or invalid`,
      )
      failures.add(commit.sha)
    }

    if (!failures.has(commit.sha)) {
      core.info(
        `Commit ${commit.sha}'s git fields passed our automated checks!`,
      )
    }
  }

  if (failures.size !== 0) {
    core.error(
      'Please add the missing commit fields. ' +
        'You can use the noreply email address generated for you by GitHub ' +
        '(https://docs.github.com/en/account-and-profile/reference/email-addresses-reference#your-noreply-email-address) ' +
        "if you'd like.",
    )
    core.setFailed('Committers: merging is discouraged.')
  }
}

module.exports = lintCommits
