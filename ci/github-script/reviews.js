// @ts-check

const eventToState = {
  COMMENT: 'COMMENTED',
  REQUEST_CHANGES: 'CHANGES_REQUESTED',
}

// Use substring checks in order to allow testing in forks
// Usernames must also end in "[bot]"
const reviewUsers = [
  'github-actions',
  'nixpkgs-ci',
  'branch-check',
  'commit-check',
  'manual-edit',
]

/**
 * @typedef {InstanceType<import('@actions/github/lib/utils').GitHub>} GitHub
 * @typedef {typeof import('@actions/github').context} Context
 *
 * @typedef {Awaited<ReturnType<GitHub['rest']['pulls']['listReviews']>>['data'][number]} Review
 * @typedef {Review & { user: NonNullable<Review['user']> }} ReviewWithNonNullUser
 */

/**
 * @param {{
 *  github: GitHub,
 *  context: Context,
 *  core: import('@actions/core'),
 *  dry: boolean,
 *  reviewKey?: string,
 * }} DismissReviewsProps
 */
async function dismissReviews({ github, context, core, dry, reviewKey }) {
  const pull_number = context.payload.pull_request?.number
  if (!pull_number) {
    core.warning('dismissReviews called outside of pull_request context')
    return
  }

  if (dry) {
    return
  }

  const allReviews = await github.paginate(github.rest.pulls.listReviews, {
    ...context.repo,
    pull_number,
  })

  const reviews = /** @type {ReviewWithNonNullUser[]} */ (
    allReviews.filter(
      (review) =>
        review.user &&
        review.state !== 'DISMISSED' &&
        review.user.login.endsWith('[bot]') &&
        reviewUsers.some((substr) => review.user?.login.includes(substr)),
    )
  )

  const reviewsByUser = reviews.reduce(
    (prev, curr) => {
      if (!(curr.user.login in prev)) {
        prev[curr.user.login] = []
      }

      prev[curr.user.login].push(curr)

      return prev
    },
    /** @type {Record<string, ReviewWithNonNullUser[]> } */ ({}),
  )

  const commentRegex = new RegExp(
    /<!-- nixpkgs review key: (.*)(?:; resolved: .*)? -->/,
  )
  const reviewKeyRegex = new RegExp(
    `<!-- (nixpkgs review key: ${reviewKey})(?:; resolved: .*)? -->`,
  )
  const commentResolvedRegex = new RegExp(
    /<!-- nixpkgs review key: .*; resolved: true -->/,
  )

  let reviewsToMinimize = reviews
  const /** @type {ReviewWithNonNullUser[]} */ reviewsToDismiss = []
  const /** @type {ReviewWithNonNullUser[]} */ reviewsToResolve = []

  if (reviewKey && reviews.every((review) => commentRegex.test(review.body))) {
    reviewsToMinimize = reviews.filter((review) =>
      reviewKeyRegex.test(review.body),
    )
  }

  for (const reviewsForUser of Object.values(reviewsByUser)) {
    // Make sure that we don't dismiss all reviews by a user if they
    // have any reviews we don't want to dismiss.
    if (
      reviewsForUser.every(
        (review) =>
          commentResolvedRegex.test(review.body) ||
          (reviewKey && reviewKeyRegex.test(review.body)) ||
          // If we are called by check-commits and the review body is clearly
          // from `commits.js`, then we can safely dismiss the review.
          // This helps with pre-existing reviews (before the comments were added).
          (reviewKey &&
            reviewKey === 'check-commits' &&
            review.body.includes('PR / Check / cherry-pick')),
      )
    ) {
      reviewsToDismiss.push(
        ...reviewsForUser.filter(
          (review) => review.state === 'CHANGES_REQUESTED',
        ),
      )
    } else {
      reviewsToResolve.push(
        ...reviewsForUser.filter(
          (review) =>
            review.state === 'CHANGES_REQUESTED' &&
            !commentResolvedRegex.test(review.body) &&
            reviewsToMinimize.some(
              (toMinimize) => toMinimize.node_id === review.node_id,
            ),
        ),
      )
    }
  }

  await Promise.all([
    ...reviewsToMinimize.map(async (review) =>
      github.graphql(
        `mutation($node_id:ID!) {
              minimizeComment(input: {
                classifier: OUTDATED,
                subjectId: $node_id
              })
              { clientMutationId }
            }`,
        { node_id: review.node_id },
      ),
    ),
    ...reviewsToDismiss.map(async (review) =>
      github.rest.pulls.dismissReview({
        ...context.repo,
        pull_number,
        review_id: review.id,
        message: 'Review dismissed automatically',
      }),
    ),
    ...reviewsToResolve.map(async (review) =>
      github.rest.pulls.updateReview({
        ...context.repo,
        pull_number,
        review_id: review.id,
        body: review.body.replace(
          reviewKeyRegex,
          `<!-- nixpkgs review key: ${reviewKey}; resolved: true -->`,
        ),
      }),
    ),
  ])
}

/**
 * @param {{
 *  github: GitHub,
 *  context: Context,
 *  core: import('@actions/core'),
 *  dry: boolean,
 *  body: string,
 *  event: keyof eventToState,
 *  reviewKey: string,
 * }} PostReviewProps
 */
async function postReview({
  github,
  context,
  core,
  dry,
  body,
  event = 'REQUEST_CHANGES',
  reviewKey,
}) {
  const pull_number = context.payload.pull_request?.number
  if (!pull_number) {
    core.warning('postReview called outside of pull_request context')
    return
  }

  const reviewKeyRegex = new RegExp(
    `<!-- (nixpkgs review key: ${reviewKey})(?:; resolved: .*)? -->`,
  )
  const reviewKeyComment = `<!-- nixpkgs review key: ${reviewKey}; resolved: false -->`
  body = body + '\n\n' + reviewKeyComment

  const reviews = (
    await github.paginate(github.rest.pulls.listReviews, {
      ...context.repo,
      pull_number,
    })
  ).filter(
    (review) =>
      review.user &&
      review.state !== 'DISMISSED' &&
      review.user.login.endsWith('[bot]') &&
      reviewUsers.some((substr) => review.user?.login.includes(substr)),
  )

  /** @type {null | Review} */
  let pendingReview
  const matchingReviews = reviews.filter((review) =>
    reviewKeyRegex.test(review.body),
  )

  if (matchingReviews.length === 0) {
    pendingReview = null
  } else if (
    matchingReviews.length === 1 &&
    matchingReviews[0].state === eventToState[event]
  ) {
    pendingReview = matchingReviews[0]
  } else {
    await dismissReviews({
      github,
      context,
      core,
      dry,
      reviewKey,
    })
    pendingReview = null
  }

  if (dry) {
    if (pendingReview)
      core.info(`pending review found: ${pendingReview.html_url}`)
    else core.info('no pending review found')
    core.info(body)
  } else {
    if (pendingReview) {
      await Promise.all([
        github.rest.pulls.updateReview({
          ...context.repo,
          pull_number,
          review_id: pendingReview.id,
          body,
        }),
        github.graphql(
          `mutation($node_id:ID!) {
              unminimizeComment(input: {
                subjectId: $node_id
              })
              { clientMutationId }
            }`,
          { node_id: pendingReview.node_id },
        ),
      ])
    } else {
      await github.rest.pulls.createReview({
        ...context.repo,
        pull_number,
        event,
        body,
      })
    }
  }
}

module.exports = {
  dismissReviews,
  postReview,
}
