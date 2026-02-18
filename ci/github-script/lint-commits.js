// @ts-check
const { classify } = require('../supportedBranches.js')
const { promisify } = require('node:util')
const execFile = promisify(require('node:child_process').execFile)

/**
 * @param {{
 *  args: string[]
 *  core: import('@actions/core'),
 *  quiet?: boolean,
 *  repoPath?: string,
 * }} RunGitProps
 */
async function runGit({ args, repoPath, core, quiet }) {
  if (repoPath) {
    args = ['-C', repoPath, ...args]
  }

  if (!quiet) {
    core.info(`About to run \`git ${args.map((s) => `'${s}'`).join(' ')}\``)
  }

  return await execFile('git', args)
}

/**
 * @param {{
 *  github: InstanceType<import('@actions/github/lib/utils').GitHub>,
 *  context: import('@actions/github/lib/context').Context,
 *  core: import('@actions/core'),
 *  repoPath?: string,
 * }} CheckCommitMessagesProps
 */
async function checkCommitMessages({ github, context, core, repoPath }) {
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

  /**
   * GitHub's API will return a maximum of 250 commits.
   * We will use it if we can, but fall back to using git locally.
   * This type is used to abstract over the differences between the two.
   * @type {{
   *  message: string,
   *  sha: string,
   * }[]}
   */
  let commits

  if (pr.commits < 250) {
    commits = (
      await github.paginate(github.rest.pulls.listCommits, {
        ...context.repo,
        pull_number,
      })
    ).map((commit) => ({ message: commit.commit.message, sha: commit.sha }))
  } else {
    await runGit({
      args: ['fetch', `--depth=1`, 'origin', pr.base.sha],
      repoPath,
      core,
    })
    await runGit({
      args: ['fetch', `--depth=${pr.commits + 1}`, 'origin', pr.head.sha],
      repoPath,
      core,
    })

    const shas = (
      await runGit({
        args: [
          'rev-list',
          `--max-count=${pr.commits}`,
          `${pr.base.sha}..${pr.head.sha}`,
        ],
        repoPath,
        core,
      })
    ).stdout
      .split('\n')
      .map((s) => s.trim())
      .filter(Boolean)

    commits = await Promise.all(
      shas.map(async (sha) => ({
        sha,
        message: (
          await runGit({
            args: ['log', '--format=%s', '-1', sha],
            repoPath,
            core,
            quiet: true,
          })
        ).stdout,
      })),
    )
  }

  const failures = new Set()

  for (const commit of commits) {
    const message = commit.message
    const firstLine = message.split('\n')[0]

    const logMsgStart = `Commit ${commit.sha}'s message's subject ("${firstLine}")`

    if (!firstLine.includes(': ')) {
      core.error(
        `${logMsgStart} was detected as not meeting our guidelines because ` +
          'it does not contain a colon followed by a whitespace.' +
          'There are likely other issues as well.',
      )
      failures.add(commit.sha)
    }

    if (firstLine.endsWith('.')) {
      core.error(
        `${logMsgStart} was detected as not meeting our guidelines because ` +
          'it ends in a period. There may be other issues as well.',
      )
      failures.add(commit.sha)
    }

    const fixups = ['amend!', 'fixup!', 'squash!']
    if (fixups.some((s) => firstLine.startsWith(s))) {
      core.error(
        `${logMsgStart} was detected as not meeting our guidelines because ` +
          `it begins with "${fixups.find((s) => firstLine.startsWith(s))}". ` +
          'Did you forget to run `git rebase -i --autosquash`?',
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
        'https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#commit-conventions, ' +
        'as well as the applicable area-specific guidelines linked there.',
    )
    core.setFailed('Committers: merging is discouraged.')
  }
}

module.exports = checkCommitMessages
