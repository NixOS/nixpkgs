/** @type {RegExp[]} */
const excludeTeams = [
  /^voters.*$/,
  /^nixpkgs-maintainers$/,
  /^nixpkgs-committers$/,
]

/**
 * @typedef {Object} ScriptContext
 * @property {any} github - GitHub API client
 * @property {any} context - GitHub Actions context
 * @property {any} core - GitHub Actions core utilities
 * @property {string} [outFile] - Optional output file path
 */

/**
 * @typedef {Object} User
 * @property {string} login - User login name
 * @property {number} id - User ID
 */

/**
 * @typedef {Object} Team
 * @property {string} slug - Team slug
 * @property {string} name - Team name
 * @property {string} description - Team description
 * @property {number} id - Team ID
 */

/**
 * @typedef {Record<string, number>} UserSet - Map of user login to user ID
 */

/**
 * @typedef {Object} TeamResult
 * @property {string} description - Team description
 * @property {number} id - Team ID
 * @property {Record<string, number>} maintainers - Team maintainers
 * @property {Record<string, number>} members - Team members
 * @property {string} name - Team name
 */

/**
 * Main script to fetch GitHub teams and their members
 * @param {ScriptContext} params - Script parameters
 * @returns {Promise<void>}
 */
module.exports = async ({ github, context, core, outFile }) => {
  const withRateLimit = require('./withRateLimit.js')
  const { writeFileSync } = require('node:fs')

  const org = context.repo.owner

  /** @type {Record<string, TeamResult>} */
  const result = {}

  await withRateLimit({ github, core }, async () => {
    /**
     * Turn an Array of users into an Object, mapping user.login -> user.id
     * @param {User[]} users - Array of users
     * @returns {Record<string, number>} Map of user login to user ID
     */
    function makeUserSet(users) {
      // Sort in-place and build result by mutation
      users.sort((a, b) => (a.login > b.login ? 1 : -1))

      return users.reduce((acc, user) => {
        acc[user.login] = user.id
        return acc
      }, {})
    }

    /**
     * Process a list of teams and append to the result variable
     * @param {Team[]} teams - Array of teams to process
     * @returns {Promise<void>}
     */
    async function processTeams(teams) {
      for (const team of teams) {
        core.notice(`Processing team ${team.slug}`)
        if (!excludeTeams.some((regex) => team.slug.match(regex))) {
          const members = makeUserSet(
            await github.paginate(github.rest.teams.listMembersInOrg, {
              org,
              team_slug: team.slug,
              role: 'member',
            }),
          )
          const maintainers = makeUserSet(
            await github.paginate(github.rest.teams.listMembersInOrg, {
              org,
              team_slug: team.slug,
              role: 'maintainer',
            }),
          )
          result[team.slug] = {
            description: team.description,
            id: team.id,
            maintainers,
            members,
            name: team.name,
          }
        }
        await processTeams(
          await github.paginate(github.rest.teams.listChildInOrg, {
            org,
            team_slug: team.slug,
          }),
        )
      }
    }

    const teams = await github.paginate(github.rest.repos.listTeams, {
      ...context.repo,
    })

    await processTeams(teams)
  })

  // Sort the teams by team name
  const sorted = Object.keys(result)
    .sort()
    .reduce((acc, key) => {
      acc[key] = result[key]
      return acc
    }, {})

  const json = `${JSON.stringify(sorted, null, 2)}\n`

  if (outFile) {
    writeFileSync(outFile, json)
  } else {
    console.log(json)
  }
}
