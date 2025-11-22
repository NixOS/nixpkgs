async function handleReviewers({
  github,
  context,
  core,
  log,
  dry,
  pull_request,
  reviews,
  user_maintainers,
  team_maintainers,
  owners,
  getUser,
}) {
  const pull_number = pull_request.number

  const users_reached = new Set([
    ...pull_request.requested_reviewers.map(({ login }) => login),
    ...reviews.map(({ user }) => user?.login).filter(Boolean),
  ])
  log('reviewers - users_reached', Array.from(users_reached).join(', '))

  const teams_reached = new Set([
    ...pull_request.requested_teams.map(({ slug }) => slug),
    ...reviews.flatMap(({ user }) => user.onBehalfOf),
  ])
  log('reviewers - teams_reached', Array.from(teams_reached).join(', '))

  // Early sanity check, before we start making any API requests. The list of maintainers
  // does not have duplicates so the only user to filter out from this list would be the
  // PR author. Therefore, we check for a limit of 15+1, where 15 is the limit we check
  // further down again.
  // This is to protect against huge treewides consuming all our API requests for no
  // reason.
  if (user_maintainers.length + team_maintainers.length > 16) {
    core.warning('Too many potential reviewers, skipping review requests.')
    // Return a boolean on whether the "needs: reviewers" label should be set.
    return users_reached.size === 0 && teams_reached.size === 0
  }

  const users = new Set([
    ...(await Promise.all(
      user_maintainers.map(async (id) => (await getUser(id)).login),
    )),
    ...owners.filter((handle) => handle && !handle.includes('/')),
  ])
    // We can't request a review from the author.
    .difference(new Set([pull_request.user?.login]))
  log('reviewers - users', Array.from(users).join(', '))

  const teams = new Set([
    ...(await Promise.all(
      team_maintainers.map(async (id) => (await getTeam(id)).slug),
    )),
    ...owners
      .map((handle) => handle.split('/'))
      .filter(([org, slug]) => org === context.repo.owner && slug)
      .map(([, slug]) => slug),
  ])
  log('reviewers - teams', Array.from(teams).join(', '))

  // Filter users to repository collaborators. If they're not, they can't be requested
  // for review. In that case, they probably missed their invite to the maintainers team.
  const reviewers = (
    await Promise.all(
      Array.from(users, async (username) => {
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

  // Similar for teams
  const team_reviewers = (
    await Promise.all(
      Array.from(teams, async (slug) => {
        try {
          await github.rest.teams.checkPermissionsForRepoInOrg({
            org: context.repo.org,
            team_slug: slug,
            owner: context.repo.org,
            repo: context.repo.repo,
          })
        } catch (e) {
          if (e.status !== 404) throw e
          core.warning(
            `PR #${pull_number}: Team ${slug} cannot be requested for review because it doesn't exist or has no repository permissions, ignoring. Probably wasn't added to the nixpkgs-maintainers team (see https://github.com/NixOS/nixpkgs/tree/master/maintainers#maintainer-teams)`,
          )
        }
      }),
    )
  ).filter(Boolean)
  log('reviewers - team_reviewers', team_reviewers.join(', '))

  if (reviewers.length + team_reviewers.length > 15) {
    core.warning(
      `Too many reviewers (users: ${reviewers.join(', ')}, teams: ${team_reviewers.join(', ')}), skipping review requests.`,
    )
    // Return a boolean on whether the "needs: reviewers" label should be set.
    return users_reached.size === 0 && teams_reached.size === 0
  }

  const non_requested_reviewers = new Set(reviewers)
    // We don't want to rerequest reviews from people who already reviewed or were requested
    .difference(users_reached)
  log(
    'reviewers - non_requested_reviewers',
    Array.from(non_requested_reviewers).join(', '),
  )
  const non_requested_team_reviewers = new Set(team_reviewers)
    // We don't want to rerequest reviews from people who already reviewed or were requested
    .difference(teams_reached)
  log(
    'reviewers - non_requested_team_reviewers',
    Array.from(non_requested_team_reviewers).join(', '),
  )

  if (non_requested_reviewers.size && non_requested_team_reviewers.size === 0) {
    log('Has reviewer changes', 'false (skipped)')
  } else if (dry) {
    core.info(
      `Requesting reviewers for #${pull_number}: ${Array.from(non_requested_reviewers).join(', ')} (dry)`,
    )
    core.info(
      `Requesting team reviewers for #${pull_number}: ${Array.from(non_requested_team_reviewers).join(', ')} (dry)`,
    )
  } else {
    // We had tried the "request all reviewers at once" thing in the past, but it didn't work out:
    //   https://github.com/NixOS/nixpkgs/commit/034613f860fcd339bd2c20c8f6bc259a2f9dc034
    // If we're hitting API errors here again, we'll need to investigate - and possibly reverse
    // course.
    await github.rest.pulls.requestReviewers({
      ...context.repo,
      pull_number,
      reviewers: non_requested_reviewers,
      team_reviewers: non_requested_team_reviewers,
    })
  }

  // Return a boolean on whether the "needs: reviewers" label should be set.
  return (
    non_requested_reviewers.size === 0 &&
    users_reached.size === 0 &&
    teams_reached.size === 0
  )
}

module.exports = {
  handleReviewers,
}
