import fs from 'node:fs'
import path from 'node:path'

import { getCommitDetailsForPR } from './get-pr-commit-details.js'
import { dismissReviews, postReview } from './reviews.js'
import { classify } from './supportedBranches.js'

/**
 * Reminders to post as a non-blocking review when a pull request touches
 * certain matching paths.
 *
 * @type {{ key: string, paths: string[] }[]}
 */
export const reminders = [
  {
    key: 'docs-styleguide',
    paths: ['doc/**', 'nixos/doc/**', 'nixos/modules/**/*.md'],
  },
]

/**
 * Translates a glob pattern into a regular expression matching paths.
 *
 * `*` matches a path segment,
 * `**` across segments.
 *
 * @param {string} pattern
 */
export function globToRegExp(pattern) {
  let source = ''

  for (let index = 0; index < pattern.length; index++) {
    const character = pattern[index]

    if (character !== '*') {
      source += character.replace(/[.+?^${}()|[\]\\]/g, '\\$&')
      continue
    }

    if (pattern[index + 1] !== '*') {
      source += '[^/]*'
      continue
    }

    index++
    if (pattern[index + 1] === '/') {
      index++
      source += '(?:.*/)?'
    } else {
      source += '.*'
    }
  }

  return new RegExp(`^${source}$`)
}

/**
 * @param {string[]} changedPaths
 * @param {string[]} patterns
 */
export function matchesAny(changedPaths, patterns) {
  const regexes = patterns.map(globToRegExp)
  return changedPaths.some((changedPath) =>
    regexes.some((regex) => regex.test(changedPath)),
  )
}

/** @param {string} key */
function reminderBody(key) {
  return fs
    .readFileSync(path.join(import.meta.dirname, 'reminders', `${key}.md`), {
      encoding: 'utf8',
    })
    .trim()
}

/**
 * @param {{
 *  github: InstanceType<typeof import('@actions/github/lib/utils').GitHub>,
 *  context: typeof import('@actions/github').context,
 *  core: typeof import('@actions/core'),
 *  repoPath?: string,
 *  dry: boolean,
 * }} PostRemindersProps
 */
export default async function postReminders({
  github,
  context,
  core,
  repoPath,
  dry,
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
