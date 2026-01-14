/**
 * @typedef {import('@actions/github/lib/context').Context} GitHubContext
 * @typedef {ReturnType<typeof import('@actions/github').getOctokit>} GitHubClient
 */

/**
 * @typedef {Object} ReviewContext
 * @property {GitHubClient} github - GitHub API client (Octokit instance)
 * @property {GitHubContext} context - GitHub Actions context
 * @property {typeof import('@actions/core')} core - GitHub Actions core utilities
 * @property {boolean} dry - Whether to run in dry-run mode
 * @property {string} [body] - Optional review body content
 */

/**
 * Dismiss all pending reviews from the github-actions bot
 * @param {ReviewContext} params - Review context parameters
 * @returns {Promise<void>}
 */
async function dismissReviews({ github, context, dry }) {
  const pull_number = context.payload.pull_request.number

  if (dry) {
    return
  }

  await Promise.all(
    (
      await github.paginate(github.rest.pulls.listReviews, {
        ...context.repo,
        pull_number,
      })
    )
      .filter((review) => review.user?.login === 'github-actions[bot]')
      .map(async (review) => {
        if (review.state === 'CHANGES_REQUESTED') {
          await github.rest.pulls.dismissReview({
            ...context.repo,
            pull_number,
            review_id: review.id,
            message: 'All good now, thank you!',
          })
        }
        await github.graphql(
          `mutation($node_id:ID!) {
            minimizeComment(input: {
              classifier: RESOLVED,
              subjectId: $node_id
            })
            { clientMutationId }
          }`,
          { node_id: review.node_id },
        )
      }),
  )
}

/**
 * Post or update a review on a pull request
 * @param {ReviewContext & { body: string }} params - Review context parameters with body
 * @returns {Promise<void>}
 */
async function postReview({ github, context, core, dry, body }) {
  const pull_number = context.payload.pull_request.number

  const pendingReview = (
    await github.paginate(github.rest.pulls.listReviews, {
      ...context.repo,
      pull_number,
    })
  ).find(
    (review) =>
      review.user?.login === 'github-actions[bot]' &&
      // If a review is still pending, we can just update this instead
      // of posting a new one.
      (review.state === 'CHANGES_REQUESTED' ||
        // No need to post a new review, if an older one with the exact
        // same content had already been dismissed.
        review.body === body),
  )

  if (dry) {
    if (pendingReview)
      core.info(`pending review found: ${pendingReview.html_url}`)
    else core.info('no pending review found')
    core.info(body)
  } else {
    if (pendingReview) {
      await github.rest.pulls.updateReview({
        ...context.repo,
        pull_number,
        review_id: pendingReview.id,
        body,
      })
    } else {
      await github.rest.pulls.createReview({
        ...context.repo,
        pull_number,
        event: 'REQUEST_CHANGES',
        body,
      })
    }
  }
}

module.exports = {
  dismissReviews,
  postReview,
}
