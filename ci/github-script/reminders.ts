import fs from 'node:fs'
import path from 'node:path'
import type * as actionsCore from '@actions/core'
import type { context as actionsContext } from '@actions/github'
import type { GitHub } from '@actions/github/lib/utils'
import { getCommitDetailsForPR } from './get-pr-commit-details.js'
import { dismissReviews, postReview } from './reviews.js'
import { classify } from './supportedBranches.js'

/**
 * Reminders to post as a non-blocking review when a pull request touches
 * certain matching paths.
 */
export const reminders: { key: string; paths: RegExp[] }[] = [
  {
    key: 'docs-styleguide',
    paths: [/^doc\//, /^nixos\/doc\//, /^nixos\/modules\/.*\.md$/],
  },
]

export function matchesAny(changedPaths: string[], patterns: RegExp[]) {
  return changedPaths.some((changedPath) =>
    patterns.some((pattern) => pattern.test(changedPath)),
  )
}

function reminderBody(key: string) {
  return fs
    .readFileSync(path.join(import.meta.dirname, 'reminders', `${key}.md`), {
      encoding: 'utf8',
    })
    .trim()
}

export default async function postReminders({
  github,
  context,
  core,
  repoPath,
  dry,
}: {
  github: InstanceType<typeof GitHub>
  context: typeof actionsContext
  core: typeof actionsCore
  repoPath?: string
  dry: boolean
}) {
  const pull_number = context.payload.pull_request?.number
  if (!pull_number) {
    core.info('This is not a pull request. Skipping reminders.')
    return
  }

  const pr = (
    await github.rest.pulls.get({
      ...context.repo,
      pull_number,
    })
  ).data

  if (pr.user.login.endsWith('[bot]')) {
    core.info('This is a bot, so reminders do not apply.')
    return
  }

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
    // We ignore them, we should only care about PRs introducing new commits.
    // We still want to run on PRs from, e.g., Someone:master to NixOS:master though.
    core.info(
      'This PR is from one development branch to another. Skipping reminders.',
    )
    return
  }

  const details = await getCommitDetailsForPR({ core, pr, repoPath })
  const changedPaths = details.flatMap(({ changedPaths }) => changedPaths)

  for (const { key, paths } of reminders) {
    if (matchesAny(changedPaths, paths)) {
      await postReview({
        github,
        context,
        core,
        dry,
        event: 'COMMENT',
        body: reminderBody(key),
        reviewKey: key,
      })
    } else {
      await dismissReviews({
        github,
        context,
        core,
        dry,
        reviewKey: key,
      })
    }
  }
}
