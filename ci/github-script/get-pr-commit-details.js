// @ts-check
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
 * GitHub's API will return a maximum of 250 commits.
 * We will use it if we can, but fall back to using git locally.
 *
 * @param {{
 *  context: import('@actions/github/lib/context').Context,
 *  core: import('@actions/core'),
 *  github: InstanceType<import('@actions/github/lib/utils').GitHub>,
 *  pr: Awaited<ReturnType<InstanceType<import('@actions/github/lib/utils').GitHub>["rest"]["pulls"]["get"]>>["data"]
 *  repoPath?: string,
 * }} GetCommitMessagesForPRProps
 *
 * @returns {Promise<{
 *  message: string,
 *  sha: string,
 * }[]>}
 */
async function getCommitDetailsForPR({ context, core, github, pr, repoPath }) {
  if (pr.commits < 250) {
    return (
      await github.paginate(github.rest.pulls.listCommits, {
        ...context.repo,
        pull_number: pr.number,
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

    return Promise.all(
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
}

module.exports = { getCommitDetailsForPR }
