module.exports = async ({ github, context, core, dry }) => {
  const { graphql } = require("@octokit/graphql")
  const withRateLimit = require('./withRateLimit.js')
  const readline = require('node:readline')
  const fs = require('fs')

  const data = fs.readFileSync(0, "utf-8")
  const lines = data.split("\n").filter((line) => line != '')

  var users = new Set()
  var teams = new Set()

  const org = context.repo.owner;

  for (var line of lines) {
    const matches = line.match(/(.*)\/(.*)/)
    if (matches) {
      if (matches[1] != org) {
        console.debug(`Team ${line} is not part of the ${org} org, ignoring`)
      } else {
        teams.add(matches[2].toLowerCase())
      }
    } else {
      users.add(line.toLowerCase())
    }
  }

  console.debug(`Checking users: ${Array.from(users)}`)
  console.debug(`Checking teams: ${Array.from(teams)}`)

  const author = context.payload.pull_request.user.login.toLowerCase();

  if (users.has(author)) {
    console.debug(`Avoiding review request for PR author ${author}`)
    users.delete(author)
  }
  console.log("Checking if users/teams have already reviewed the PR")

  const reviews = (await github.graphql(
    `query($owner: String!, $repo: String!, $pr: Int!) {
      repository(owner: $owner, name: $repo) {
        pullRequest(number: $pr) {
          reviews(first: 100) {
            nodes {
              author {
                login
              }
              onBehalfOf(first: 100) {
                nodes {
                  slug
                }
              }
            }
          }
        }
      }
    }`,
    {
      owner: org,
      repo: context.repo.repo,
      pr: context.payload.pull_request.number,
    },
  )).repository.pullRequest.reviews.nodes

  for (var review of reviews) {
    if (users.delete(review.author.login.toLowerCase())) {
      console.debug(`Avoiding review request for user ${review.author.login}, who has already left a review`)
    }

    for (var team of review.onBehalfOf.nodes) {
      if (teams.delete(team.slug.toLowerCase())) {
        console.debug(`Avoiding review request for team ${team.slug}, who has already left a review`)
      }
    }
  }

  console.debug("Checking that all users/teams can be requested for review")

  for (var user of users) {
    try {
      await github.rest.repos.checkCollaborator({
        owner: org,
        repo: context.repo.repo,
        username: user,
      })
    } catch (e) {
      if (e.status == 404) {
        console.debug(`User ${user} cannot be requested for review because they don't exist or are not a repository collaborator, ignoring. Probably missed the automated invite to the maintainers team (see <https://github.com/NixOS/nixpkgs/issues/234293>)`)
        users.delete(user)
      } else {
        throw e
      }
    }
  }

  for (var team of teams) {
    try {
      await github.rest.teams.checkPermissionsForRepoInOrg({
        org,
        team_slug: team,
        owner: org,
        repo: context.repo.repo,
      })
    } catch (e) {
      if (e.status == 404) {
        console.debug(`Team ${team} cannot be requested for review because it doesn't exist or has no repository permissions, ignoring. Probably wasn't added to the nixpkgs-maintainers team (see https://github.com/NixOS/nixpkgs/tree/master/maintainers#maintainer-teams)`)
        teams.delete(team)
      } else {
        throw e
      }
    }
  }

  console.debug(`Would request reviews from users: ${Array.from(users)}`)
  console.debug(`Would request reviews from teams: ${Array.from(teams)}`)

  if (users.size + teams.size > 10) {
    console.debug("Too many reviewers, skipping review requests")
    return
  }

  for (var user of users) {
    console.debug(`Requesting review from user ${user}`)
    if (dry) {
      console.debug("Skipping in dry mode")
    } else {
      github.rest.pulls.requestReviewers({
        owner: org,
        repo: context.repo.repo,
        pull_number: context.payload.pull_request.number,
        reviewers: [user],
      })
    }
  }

  for (var team of teams) {
    console.debug(`Requesting review from team ${team}`)
    if (dry) {
      console.debug("Skipping in dry mode")
    } else {
      github.rest.pulls.requestReviewers({
        owner: org,
        repo: context.repo.repo,
        pull_number: context.payload.pull_request.number,
        team_reviewers: [team],
      })
    }
  }
}
