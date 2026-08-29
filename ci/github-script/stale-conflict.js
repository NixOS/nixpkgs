// Two-step handling of stale PRs stuck on a merge conflict:
//   1. Once the merge-conflict label has been present for > MERGE_CONFLICT_DAYS,
//      post a single comment nudging the author to rebase.
//   2. If that nudge is older than NUDGE_TO_DRAFT_DAYS, convert the PR to a draft.
// Step 2 can only run after step 1, because its timer starts at the nudge.

const MERGE_CONFLICT_DAYS = 30 // conflicted this long before nudging (~1 month)
const NUDGE_TO_DRAFT_DAYS = 15 // nudge this old before drafting (~2 weeks)
const DAY_MS = 24 * 60 * 60 * 1000
const MERGE_CONFLICT_LABEL = '2.status: merge conflict'
// Hidden marker to recognise our own nudge on later runs (cf. merge.js).
const NUDGE_MARKER = '<!-- nixpkgs-ci: stale-merge-conflict-nudge -->'

// Date since when the merge-conflict label has been continuously present, or
// null if it isn't currently set / can't be determined from the timeline.
function mergeConflictSince(events) {
  let since = null
  for (const { event, label, created_at } of [...events].sort(
    (a, b) => new Date(a.created_at) - new Date(b.created_at),
  )) {
    if (label?.name !== MERGE_CONFLICT_LABEL) continue
    if (event === 'labeled') since = new Date(created_at)
    else if (event === 'unlabeled') since = null
  }
  return since
}

async function handleStaleConflict({
  github,
  context,
  log,
  dry,
  item,
  events,
}) {
  // Only PRs can be merge-conflicted or drafted. Staleness is the caller's job.
  if (!(item.pull_request || context.payload.pull_request)) return
  if (!item.labels.some(({ name }) => name === MERGE_CONFLICT_LABEL)) return
  // Don't nudge or draft PRs the author has already parked as a draft.
  if (item.draft) return log('stale-conflict', 'already a draft', true)

  const conflict_since = mergeConflictSince(events)
  // Conservative: don't act if we can't prove how long the conflict has lasted.
  if (!conflict_since)
    return log('stale-conflict', 'merge conflict duration unknown', true)

  const conflict_age_days = (Date.now() - conflict_since) / DAY_MS
  log('stale-conflict - conflicted for (days)', conflict_age_days.toFixed(1))
  if (conflict_age_days < MERGE_CONFLICT_DAYS)
    return log('stale-conflict', 'merge conflict too recent', true)

  const nudge = events.find(
    ({ event, body }) => event === 'commented' && body?.includes(NUDGE_MARKER),
  )

  if (!nudge) {
    const body = [
      NUDGE_MARKER,
      `@${item.user?.login} This pull request is marked as stale and has had a merge conflict with its target branch for over a month.`,
      '',
      'To get it moving again:',
      '',
      '- Rebase it against the target branch and resolve the merge conflict. See [How to create pull requests](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#how-to-create-pull-requests) part 7.',
      '- If the PR is ready but has not been reviewed, see [I opened a PR, how do I get it merged?](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#i-opened-a-pr-how-do-i-get-it-merged).',
      '',
      `If no action is taken, this pull request will be automatically marked as a draft in ${NUDGE_TO_DRAFT_DAYS} days. You can un-draft at any time, once you believe the PR is ready to be merged.`,
    ].join('\n')

    if (dry) return log('stale-conflict', 'would post rebase nudge (dry)')
    await github.rest.issues.createComment({
      ...context.repo,
      issue_number: item.number,
      body,
    })
    return log('stale-conflict', 'posted rebase nudge')
  }

  const nudged_at = new Date(nudge.created_at)

  // Already drafted after the nudge: nothing left to do.
  if (
    events.some(
      ({ event, created_at }) =>
        event === 'convert_to_draft' && new Date(created_at) > nudged_at,
    )
  )
    return log('stale-conflict', 'already converted to draft after nudge', true)

  if ((Date.now() - nudged_at) / DAY_MS < NUDGE_TO_DRAFT_DAYS)
    return log('stale-conflict', 'grace period after nudge not over yet', true)

  if (dry) return log('stale-conflict', 'would convert to draft (dry)')

  try {
    await github.graphql(
      `mutation($id: ID!) {
        convertPullRequestToDraft(input: { pullRequestId: $id }) {
          clientMutationId
        }
      }`,
      { id: item.node_id },
    )
  } catch (e) {
    // Don't fail the whole bot run over a single PR (e.g. already a draft).
    return log(
      'stale-conflict',
      `convert to draft failed: ${e.message ?? e}`,
      true,
    )
  }

  await github.rest.issues.createComment({
    ...context.repo,
    issue_number: item.number,
    body: [
      'This pull request has been marked as a draft because the merge conflict was not resolved after the previous reminder.',
      '',
      'You can un-draft at any time, once you believe the PR is ready to be merged.',
    ].join('\n'),
  })
  log('stale-conflict', 'converted to draft')
}

module.exports = {
  handleStaleConflict,
}
