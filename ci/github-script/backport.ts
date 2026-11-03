// Records the outcome of korthout/backport-action as labels on the source pull request.

export default async function labelBackport({
  github,
  context,
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

  const labels: string[] = []
  if (createdPullNumbers.trim() !== '') labels.push('8.has: port to stable')
  if (wasSuccessful === 'false') labels.push('8.has: failed backport')

  if (labels.length > 0) {
    await github.rest.issues.addLabels({
      ...context.repo,
      issue_number,
      labels,
    })
  }
}
