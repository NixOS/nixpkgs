import type * as actionsCore from '@actions/core'
import type { context as actionsContext } from '@actions/github'
import type { GitHub } from '@actions/github/lib/utils'

// Two-step handling of stale PRs stuck on a merge conflict:
//   1. Once the merge-conflict label has been present for > MERGE_CONFLICT_DAYS,
//      post a single comment nudging the author to rebase, and record that with
//      NUDGE_LABEL.
//   2. If the nudge label has been present for > NUDGE_TO_DRAFT_DAYS, convert the
//      PR to a draft.
// Step 2 can only run after step 1, because its timer starts at the nudge.
//
// Both timers are derived from label events, so a conflict that gets resolved
// and later comes back starts from scratch instead of inheriting the previous
// episode's nudge. The bot re-derives the merge-conflict label on every run,
// so episodes are routine.

const MERGE_CONFLICT_DAYS = 30 // conflicted this long before nudging (~1 month)
const NUDGE_TO_DRAFT_DAYS = 15 // nudged this old before drafting (~2 weeks)
const DAY_MS = 24 * 60 * 60 * 1000
const MERGE_CONFLICT_LABEL = '2.status: merge conflict'
const NUDGE_LABEL = '2.status: rebase nudge'

// The subset of an issue timeline event we care about. Events are deliberately
// typed structurally rather than pulled from the octokit union: the timeline
// endpoint returns dozens of event shapes, and requiring the full union here
// would mean every caller has to narrow all of them.
type TimelineEvent = {
  event?: string
  created_at?: string
  label?: { name?: string } | null
}

// The subset of an issue (or of a `pull_request` webhook payload) we read.
// `item` may come from either the search API, `issues.listForRepo`, or a
// webhook payload, so only the common ground is required.
type StaleItem = {
  number: number
  node_id: string
  draft?: boolean
  user?: { login?: string } | null
  pull_request?: unknown
}

type LogFn = (key: string, value: unknown, skip?: boolean) => void

function errorMessage(e: unknown): string {
  return e instanceof Error ? e.message : String(e)
}

function errorStatus(e: unknown): number | undefined {
  if (typeof e !== 'object' || e === null || !('status' in e)) return undefined
  return typeof e.status === 'number' ? e.status : undefined
}

// Events without a timestamp sort first, so they can never fabricate a "since"
// date for the label we care about.
function timestamp({ created_at }: TimelineEvent): number {
  return created_at ? new Date(created_at).getTime() : 0
}

// Date since when `name` has been continuously applied, or null if it isn't
// currently applied. Events are sorted because the timeline is only guaranteed
// to be in order per page.
function labelPresentSince(events: TimelineEvent[], name: string): Date | null {
  let since: Date | null = null
  for (const { event, label, created_at } of [...events].sort(
    (a, b) => timestamp(a) - timestamp(b),
  )) {
    if (label?.name !== name) continue
    if (event === 'labeled' && created_at) since = new Date(created_at)
    else if (event === 'unlabeled') since = null
  }
  return since
}

export async function handleStaleConflict({
  github,
  context,
  core,
  log,
  dry,
  item,
  events,
}: {
  github: InstanceType<typeof GitHub>
  context: typeof actionsContext
  core: typeof actionsCore
  log: LogFn
  dry: boolean
  item: StaleItem
  events: TimelineEvent[]
}) {
  // Best-effort bookkeeping: a 404 on removal just means the label is already
  // gone, which is the state we wanted anyway.
  async function setLabel(name: string, present: boolean): Promise<void> {
    if (dry) {
      const action = present ? 'add' : 'remove'
      return log('stale-conflict', `would ${action} '${name}' (dry)`)
    }
    try {
      if (present) {
        await github.rest.issues.addLabels({
          ...context.repo,
          issue_number: item.number,
          labels: [name],
        })
      } else {
        await github.rest.issues.removeLabel({
          ...context.repo,
          issue_number: item.number,
          name,
        })
      }
    } catch (e) {
      if (present || errorStatus(e) !== 404) {
        core.error(
          `#${item.number} - stale-conflict: label '${name}' update failed: ${errorMessage(e)}`,
        )
      }
    }
  }

  // Only PRs can be merge-conflicted or drafted. Staleness is the caller's job.
  if (!(item.pull_request || context.payload.pull_request)) return

  const conflict_since = labelPresentSince(events, MERGE_CONFLICT_LABEL)
  const nudge_since = labelPresentSince(events, NUDGE_LABEL)

  // A nudge that predates the current conflict tells us nothing about this
  // episode, so drop it and let the next run start over from the conflict label.
  if (nudge_since && (!conflict_since || nudge_since < conflict_since)) {
    await setLabel(NUDGE_LABEL, false)
    return log('stale-conflict', 'cleared nudge from earlier conflict', true)
  }

  // Don't nudge or draft PRs the author has already parked as a draft.
  if (item.draft) return log('stale-conflict', 'already a draft', true)

  // Conservative: don't act if we can't prove how long the conflict has lasted.
  if (!conflict_since)
    return log('stale-conflict', 'merge conflict duration unknown', true)

  const conflict_age_days = (Date.now() - conflict_since.getTime()) / DAY_MS
  log('stale-conflict - conflicted for (days)', conflict_age_days.toFixed(1))
  if (conflict_age_days < MERGE_CONFLICT_DAYS)
    return log('stale-conflict', 'merge conflict too recent', true)

  if (!nudge_since) {
    const body = [
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
    try {
      // Comment before labelling: if labelling then fails we would leave a PR
      // marked as nudged without ever having warned it, which is the one order
      // that breaks the "always warn first" guarantee. The reverse only risks a
      // duplicate nudge.
      await github.rest.issues.createComment({
        ...context.repo,
        issue_number: item.number,
        body,
      })
      await setLabel(NUDGE_LABEL, true)
    } catch (e) {
      return core.error(
        `#${item.number} - stale-conflict: rebase nudge failed: ${errorMessage(e)}`,
      )
    }
    return log('stale-conflict', 'posted rebase nudge')
  }

  // Already drafted after the nudge: nothing left to do.
  if (
    events.some(
      ({ event, created_at }) =>
        event === 'convert_to_draft' &&
        created_at !== undefined &&
        new Date(created_at) > nudge_since,
    )
  )
    return log('stale-conflict', 'already converted to draft after nudge', true)

  const nudge_age_days = (Date.now() - nudge_since.getTime()) / DAY_MS
  if (nudge_age_days < NUDGE_TO_DRAFT_DAYS)
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

    await github.rest.issues.createComment({
      ...context.repo,
      issue_number: item.number,
      body: [
        'This pull request has been marked as a draft because the merge conflict was not resolved after the previous reminder.',
        '',
        'You can un-draft at any time, once you believe the PR is ready to be merged.',
      ].join('\n'),
    })
  } catch (e) {
    // Don't fail the whole bot run over a single PR (e.g. already a draft).
    // core.error only annotates the run, unlike core.setFailed it does not
    // set a non-zero exit code.
    core.error(
      `#${item.number} - stale-conflict: convert to draft failed: ${errorMessage(e)}`,
    )
    return
  }

  log('stale-conflict', 'converted to draft')
}
