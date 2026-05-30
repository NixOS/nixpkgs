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
  getTeam,
}) {
  const pull_number = pull_request.number

  // Users that the PR has already reached, e.g. they've left a review or have been requested for one
  const users_reached = new Set([
    ...pull_request.requested_reviewers.map(({ login }) => login.toLowerCase()),
    ...reviews.map(({ user }) => user.login.toLowerCase()),
  ])
  log('reviewers - users_reached', Array.from(users_reached).join(', '))

  // Same for teams
  const teams_reached = new Set([
    ...pull_request.requested_teams.map(({ slug }) => slug.toLowerCase()),
    ...reviews.flatMap(({ onBehalfOf }) =>
      onBehalfOf.nodes.map(({ slug }) => slug.toLowerCase()),
    ),
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

  // Users that should be reached
  var users_to_reach = new Set([
    ...(
      await Promise.all(
        user_maintainers.map(async (id) => {
          const user = await getUser(id)
          // User may have deleted their account
          return user?.login?.toLowerCase()
        }),
      )
    ).filter(Boolean),
    ...owners
      .filter((handle) => handle && !handle.includes('/'))
      .map((handle) => handle.toLowerCase()),
  ])
    // We can't request a review from the author.
    .difference(new Set([pull_request.user?.login.toLowerCase()]))

  // Filter users to repository collaborators. If they're not, they can't be requested
  // for review. In that case, they probably missed their invite to the maintainers team.
  users_to_reach = new Set(
    (
      await Promise.all(
        Array.from(users_to_reach, async (username) => {
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
    ).filter(Boolean),
  )
  log('reviewers - users_to_reach', Array.from(users_to_reach).join(', '))

  // Similar for teams
  var teams_to_reach = new Set([
    ...(
      await Promise.all(
        team_maintainers.map(async (id) => {
          const team = await getTeam(id)
          // Team may have been deleted
          return team?.slug?.toLowerCase()
        }),
      )
    ).filter(Boolean),
    ...owners
      .map((handle) => handle.split('/'))
      .filter(
        ([org, slug]) =>
          org.toLowerCase() === context.repo.owner.toLowerCase() && slug,
      )
      .map(([, slug]) => slug.toLowerCase()),
  ])
  teams_to_reach = new Set(
    (
      await Promise.all(
        Array.from(teams_to_reach, async (slug) => {
          try {
            await github.rest.teams.checkPermissionsForRepoInOrg({
              org: context.repo.owner,
              team_slug: slug,
              owner: context.repo.owner,
              repo: context.repo.repo,
            })
            return slug
          } catch (e) {
            if (e.status !== 404) throw e
            core.warning(
              `PR #${pull_number}: Team ${slug} cannot be requested for review because it doesn't exist or has no repository permissions, ignoring. Probably wasn't added to the nixpkgs-maintainers team (see https://github.com/NixOS/nixpkgs/tree/master/maintainers#maintainer-teams)`,
            )
          }
        }),
      )
    ).filter(Boolean),
  )
  log('reviewers - teams_to_reach', Array.from(teams_to_reach).join(', '))

  if (users_to_reach.size + teams_to_reach.size > 15) {
    core.warning(
      `Too many reviewers (users: ${Array.from(users_to_reach).join(', ')}, teams: ${Array.from(teams_to_reach).join(', ')}), skipping review requests.`,
    )
    // Return a boolean on whether the "needs: reviewers" label should be set.
    return users_reached.size === 0 && teams_reached.size === 0
  }

  // We don't want to rerequest reviews from people who already reviewed or were requested
  const users_not_yet_reached = Array.from(
    users_to_reach.difference(users_reached),
  )
  log('reviewers - users_not_yet_reached', users_not_yet_reached.join(', '))
  // We don't want to rerequest reviews from teams who already reviewed or were requested
  const teams_not_yet_reached = Array.from(
    teams_to_reach.difference(teams_reached),
  )
  log('reviewers - teams_not_yet_reached', teams_not_yet_reached.join(', '))

  if (
    users_not_yet_reached.length === 0 &&
    teams_not_yet_reached.length === 0
  ) {
    log('Has reviewer changes', 'false (skipped)')
  } else if (dry) {
    core.info(
      `Requesting user reviewers for #${pull_number}: ${users_not_yet_reached.join(', ')} (dry)`,
    )
    core.info(
      `Requesting team reviewers for #${pull_number}: ${teams_not_yet_reached.join(', ')} (dry)`,
    )
  } else {
    // We had tried the "request all reviewers at once" thing in the past, but it didn't work out:
    //   https://github.com/NixOS/nixpkgs/commit/034613f860fcd339bd2c20c8f6bc259a2f9dc034
    // If we're hitting API errors here again, we'll need to investigate - and possibly reverse
    // course.
    await github.rest.pulls.requestReviewers({
      ...context.repo,
      pull_number,
      reviewers: users_not_yet_reached,
      team_reviewers: teams_not_yet_reached,
    })
  }

  // Return a boolean on whether the "needs: reviewers" label should be set.
  return (
    users_not_yet_reached.length === 0 &&
    teams_not_yet_reached.length === 0 &&
    users_reached.size === 0 &&
    teams_reached.size === 0
  )
}

module.exports = {
  handleReviewers,
}
