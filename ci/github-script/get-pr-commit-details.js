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
 * Gets the SHA, subject and changed files for each commit in the given PR.
 *
 * Don't use GitHub API at all: the "list commits on PR" endpoint has a limit
 * of 250 commits and doesn't return the changed files.
 *
 * @param {{
 *  core: import('@actions/core'),
 *  pr: Awaited<ReturnType<InstanceType<import('@actions/github/lib/utils').GitHub>["rest"]["pulls"]["get"]>>["data"]
 *  repoPath?: string,
 * }} GetCommitMessagesForPRProps
 *
 * @returns {Promise<{
 *  subject: string,
 *  sha: string,
 *  changedPaths: string[],
 *  changedPathSegments: Set<string>,
 * }[]>}
 */
async function getCommitDetailsForPR({ core, pr, repoPath }) {
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
    shas.map(async (sha) => {
      // Subject first, then a blank line, then filenames.
      const result = (
        await runGit({
          args: ['log', '--format=%s', '--name-only', '-1', sha],
          repoPath,
          core,
          quiet: true,
        })
      ).stdout.split('\n')

      const subject = result[0]

      const changedPaths = result.slice(2, -1)

      const changedPathSegments = new Set(
        changedPaths.flatMap((path) => path.split('/')),
      )

      return {
        sha,
        subject,
        changedPaths,
        changedPathSegments,
      }
    }),
  )
}

module.exports = { getCommitDetailsForPR }
