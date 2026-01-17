async function handleReviewers({
  github,
  context,
  core,
  log,
  dry,
  pull_request,
  reviews,
  maintainers,
  owners,
  getTeamMembers,
  getUser,
}) {
  const pull_number = pull_request.number

  const requested_reviewers = new Set(
    pull_request.requested_reviewers.map(({ login }) => login.toLowerCase()),
  )
  log(
    'reviewers - requested_reviewers',
    Array.from(requested_reviewers).join(', '),
  )

  const existing_reviewers = new Set(
    reviews.map(({ user }) => user?.login.toLowerCase()).filter(Boolean),
  )
  log(
    'reviewers - existing_reviewers',
    Array.from(existing_reviewers).join(', '),
  )

  // Early sanity check, before we start making any API requests. The list of maintainers
  // does not have duplicates so the only user to filter out from this list would be the
  // PR author. Therefore, we check for a limit of 15+1, where 15 is the limit we check
  // further down again.
  // This is to protect against huge treewides consuming all our API requests for no
  // reason.
  if (maintainers.length > 16) {
    core.warning('Too many potential reviewers, skipping review requests.')
    // Return a boolean on whether the "needs: reviewers" label should be set.
    return existing_reviewers.size === 0 && requested_reviewers.size === 0
  }

  const users = new Set([
    ...(await Promise.all(
      maintainers.map(async (id) => (await getUser(id)).login.toLowerCase()),
    )),
    ...owners
      .filter((handle) => handle && !handle.includes('/'))
      .map((handle) => handle.toLowerCase()),
  ])
  log('reviewers - users', Array.from(users).join(', '))

  const teams = new Set(
    owners
      .map((handle) => handle.split('/'))
      .filter(([org, slug]) => org === context.repo.owner && slug)
      .map(([, slug]) => slug),
  )
  log('reviewers - teams', Array.from(teams).join(', '))

  const team_members = new Set(
    (await Promise.all(Array.from(teams, getTeamMembers)))
      .flat(1)
      .map(({ login }) => login.toLowerCase()),
  )
  log('reviewers - team_members', Array.from(team_members).join(', '))

  const new_reviewers = users
    .union(team_members)
    // We can't request a review from the author.
    .difference(new Set([pull_request.user?.login.toLowerCase()]))
  log('reviewers - new_reviewers', Array.from(new_reviewers).join(', '))

  // Filter users to repository collaborators. If they're not, they can't be requested
  // for review. In that case, they probably missed their invite to the maintainers team.
  const reviewers = (
    await Promise.all(
      Array.from(new_reviewers, async (username) => {
        // TODO: Restructure this file to only do the collaborator check for those users
        // who were not already part of a team. Being a member of a team makes them
        // collaborators by definition.
        try {
          await github.rest.repos.checkCollaborator({
            ...context.repo,
            username,
          })
          return username
        } catch (e) {
          if (e.status !== 404) throw e
          core.warning(
            `PR #${pull_number}: User ${username} cannot be requested for review because they don't exist or are not a repository collaborator, ignoring. They probably missed the automated invite to the maintainers team (see <https://github.com/NixOS/nixpkgs/issues/234293>).`,
          )
        }
      }),
    )
  ).filter(Boolean)
  log('reviewers - reviewers', reviewers.join(', '))

  if (reviewers.length > 15) {
    core.warning(
      `Too many reviewers (${reviewers.join(', ')}), skipping review requests.`,
    )
    // Return a boolean on whether the "needs: reviewers" label should be set.
    return existing_reviewers.size === 0 && requested_reviewers.size === 0
  }

  const non_requested_reviewers = new Set(reviewers)
    .difference(requested_reviewers)
    // We don't want to rerequest reviews from people who already reviewed.
    .difference(existing_reviewers)
  log(
    'reviewers - non_requested_reviewers',
    Array.from(non_requested_reviewers).join(', '),
  )

  if (non_requested_reviewers.size === 0) {
    log('Has reviewer changes', 'false (skipped)')
  } else if (dry) {
    core.info(
      `Requesting reviewers for #${pull_number}: ${Array.from(non_requested_reviewers).join(', ')} (dry)`,
    )
  } else {
    // We had tried the "request all reviewers at once" thing in the past, but it didn't work out:
    //   https://github.com/NixOS/nixpkgs/commit/034613f860fcd339bd2c20c8f6bc259a2f9dc034
    // If we're hitting API errors here again, we'll need to investigate - and possibly reverse
    // course.
    await github.rest.pulls.requestReviewers({
      ...context.repo,
      pull_number,
      reviewers,
    })
  }

  // Return a boolean on whether the "needs: reviewers" label should be set.
  return (
    non_requested_reviewers.size === 0 &&
    existing_reviewers.size === 0 &&
    requested_reviewers.size === 0
  )
}

module.exports = {
  handleReviewers,
}
