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
