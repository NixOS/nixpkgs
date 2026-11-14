import assert from 'node:assert/strict'
import { execFileSync } from 'node:child_process'
import { mkdtemp, rm } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { test } from 'node:test'
import lintCommits from './lint-commits.ts'

type LintProps = Parameters<typeof lintCommits>[0]

test('lints real PR history and exempts development merges only within the same repository', async (t) => {
  const directory = await mkdtemp(join(tmpdir(), 'lint-commits-'))
  t.after(() => rm(directory, { recursive: true, force: true }))

  const origin = join(directory, 'origin')
  const checkout = join(directory, 'checkout')
  function git(repo: string, ...args: string[]) {
    return execFileSync('git', ['-C', repo, ...args], {
      encoding: 'utf8',
      env: {
        ...process.env,
        GIT_CONFIG_NOSYSTEM: '1',
        GIT_CONFIG_GLOBAL: '/dev/null',
        GIT_AUTHOR_NAME: 'Test Author',
        GIT_AUTHOR_EMAIL: 'author@example.com',
        GIT_COMMITTER_NAME: 'Test Committer',
        GIT_COMMITTER_EMAIL: 'committer@example.com',
      },
      stdio: ['ignore', 'pipe', 'pipe'],
    }).trim()
  }

  git(directory, 'init', '--initial-branch=master', origin)
  git(origin, 'commit', '--allow-empty', '-m', 'example: initial commit')
  const base = git(origin, 'rev-parse', 'HEAD')
  git(origin, 'checkout', '-b', 'topic')
  git(origin, 'commit', '--allow-empty', '-m', 'example: topic change')
  const linear = git(origin, 'rev-parse', 'HEAD')
  git(origin, 'checkout', '-b', 'side', base)
  git(origin, 'commit', '--allow-empty', '-m', 'example: side change')
  git(origin, 'checkout', 'topic')
  git(origin, 'merge', '--no-ff', 'side', '-m', 'example: merge side')
  const merge = git(origin, 'rev-parse', 'HEAD')
  git(origin, 'checkout', '-b', 'tabbed-subject')
  git(origin, 'commit', '--amend', '-m', 'example: merge\tside')
  const tabbedMerge = git(origin, 'rev-parse', 'HEAD')
  git(directory, 'clone', '--depth=1', `file://${origin}`, checkout)

  const cases = [
    {
      name: 'linear history',
      sha: linear,
      commits: 1,
      ref: 'topic',
      repo: 2,
      fails: false,
    },
    {
      name: 'merge commit',
      sha: merge,
      commits: 3,
      ref: 'topic',
      repo: 1,
      fails: true,
    },
    {
      name: 'merge commit with a tab in its subject',
      sha: tabbedMerge,
      commits: 3,
      ref: 'tabbed-subject',
      repo: 2,
      fails: true,
    },
    {
      name: 'development merge',
      sha: merge,
      commits: 3,
      ref: 'staging-next',
      repo: 1,
      fails: false,
    },
    {
      name: 'fork development branch',
      sha: merge,
      commits: 3,
      ref: 'master',
      repo: 2,
      fails: true,
    },
  ]

  for (const { name, sha, commits, ref, repo, fails } of cases) {
    await t.test(name, async () => {
      const failures: string[] = []
      const errors: string[] = []
      const pr = {
        commits,
        base: { sha: base, ref: 'master', repo: { id: 1 } },
        head: { sha, ref, repo: { id: repo } },
      }

      await lintCommits({
        github: {
          rest: { pulls: { get: async () => ({ data: pr }) } },
        } as unknown as LintProps['github'],
        context: {
          repo: { owner: 'test', repo: 'test' },
          payload: { pull_request: { number: 1 } },
        } as LintProps['context'],
        core: {
          info: () => {},
          error: (message: string) => errors.push(message),
          setFailed: (message: string) => failures.push(message),
        } as unknown as LintProps['core'],
        repoPath: checkout,
      })

      assert.equal(failures.length, fails ? 1 : 0)
      if (fails) {
        assert.equal(failures[0], 'Committers: merging is discouraged.')
        assert.equal(errors[0], `Commit ${sha} is a merge commit.`)
      } else {
        assert.deepEqual(errors, [])
      }
    })
  }
})
