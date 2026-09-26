import { execFile as nodeExecFile } from 'node:child_process'
import { promisify } from 'node:util'

const execFile = promisify(nodeExecFile)

/**
 * @typedef {{
 *  subject: string,
 *  sha: string,
 *  author: { name: string, email: string },
 *  committer: { name: string, email: string}
 *  changedPaths: string[],
 *  changedPathSegments: Set<string>,
 * }} Commit
 */

/**
 * @param {{
 *  args: string[]
 *  core: typeof import('@actions/core'),
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
 *  core: typeof import('@actions/core'),
 *  pr: Awaited<ReturnType<InstanceType<typeof import('@actions/github/lib/utils').GitHub>["rest"]["pulls"]["get"]>>["data"]
 *  repoPath?: string,
 * }} GetCommitMessagesForPRProps
 *
 * @returns {Promise<Commit[]>}
 */
export async function getCommitDetailsForPR({ core, pr, repoPath }) {
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
      // Subject, author name, author email, committer name, committer email (all tab-separated)
      // then a blank line, then filenames.
      const result = (
        await runGit({
          args: [
            'log',
            '--format=%s\t%aN\t%aE\t%cN\t%cE',
            '--name-only',
            '-1',
            sha,
          ],
          repoPath,
          core,
          quiet: true,
        })
      ).stdout.split('\n')

      const [subject, authorName, authorEmail, committerName, committerEmail] =
        result[0].split('\t')

      const changedPaths = result.slice(2, -1)

      const changedPathSegments = new Set(
        changedPaths.flatMap((path) => path.split('/')),
      )

      return {
        sha,
        subject,
        author: { name: authorName, email: authorEmail },
        committer: { name: committerName, email: committerEmail },
        changedPaths,
        changedPathSegments,
      }
    }),
  )
}
