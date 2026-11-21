// Records the outcome of korthout/backport-action as labels on the source pull request.
//
// This runs after every backport attempt: on merge, on a re-run of the workflow, and when another
// `backport <branch>` label is added. Each attempt covers all `backport <branch>` labels.

const failedLabel = '8.has: failed backport'
const portedLabel = '8.has: port to stable'

export default async function labelBackport({
  github,
  context,
  core,
  wasSuccessful,
  createdPullNumbers,
}: {
  github: InstanceType<typeof import('@actions/github/lib/utils').GitHub>
  context: typeof import('@actions/github').context
  core: typeof import('@actions/core')
  // The `was_successful` output: 'true' or 'false'.
  wasSuccessful: string
  // The `created_pull_numbers` output: space-separated, empty if no pull request was created.
  createdPullNumbers: string
}) {
  const issue_number = context.payload.pull_request?.number
  if (!issue_number) throw new Error('This is not a pull request.')

  // Not context.payload.pull_request.labels: a re-run reuses the original event payload,
  // which predates any label added by an earlier attempt.
  const before = new Set(
    (
      await github.paginate(github.rest.issues.listLabelsOnIssue, {
        ...context.repo,
        issue_number,
      })
    ).map(({ name }) => name),
  )

  const after = new Set(before)

  if (createdPullNumbers.trim() !== '') after.add(portedLabel)

  // A target that already has a backport pull request, or already contains the changes, is
  // skipped rather than failed. So 'true' means nothing is outstanding, and a successful
  // re-run clears the failure from an earlier attempt.
  if (wasSuccessful === 'false') after.add(failedLabel)
  if (wasSuccessful === 'true') after.delete(failedLabel)

  const added = [...after.difference(before)]
  if (added.length > 0) {
    core.info(`Adding labels: ${added.join(', ')}`)
    await github.rest.issues.addLabels({
      ...context.repo,
      issue_number,
      labels: added,
    })
  }

  for (const name of before.difference(after)) {
    core.info(`Removing label: ${name}`)
    await github.rest.issues.removeLabel({
      ...context.repo,
      issue_number,
      name,
    })
  }
}
