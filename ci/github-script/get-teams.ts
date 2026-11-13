import { writeFileSync } from 'node:fs'
import withRateLimit from './withRateLimit.ts'

const excludeTeams = [
  /^voters.*$/,
  /^nixpkgs-maintainers$/,
  /^nixpkgs-committers$/,
]

type GitHub = InstanceType<typeof import('@actions/github/lib/utils').GitHub>
type Context = typeof import('@actions/github').context
type Core = typeof import('@actions/core')
type Team = Awaited<
  ReturnType<GitHub['rest']['repos']['listTeams']>
>['data'][number]
type User = Awaited<
  ReturnType<GitHub['rest']['teams']['listMembersInOrg']>
>['data'][number]

interface Result {
  [slug: string]: {
    description: string | null
    id: number
    maintainers: unknown
    members: unknown
    name: string
  }
}

export default async ({
  github,
  context,
  core,
  outFile,
}: {
  github: GitHub
  context: Context
  core: Core
  outFile: string
}) => {
  const org = context.repo.owner

  const result: Result = {}

  await withRateLimit({ github, core }, async () => {
    // Turn an Array of users into an Object, mapping user.login -> user.id
    function makeUserSet(users: User[]) {
      // Sort in-place and build result by mutation
      users.sort((a, b) => (a.login > b.login ? 1 : -1))

      return users.reduce(
        (acc, user) => {
          acc[user.login] = user.id
          return acc
        },
        {} as { [login: string]: number },
      )
    }

    // Process a list of teams and append to the result variable
    async function processTeams(teams: Team[]) {
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
    }, {} as Result)

  const json = `${JSON.stringify(sorted, null, 2)}\n`

  if (outFile) {
    writeFileSync(outFile, json)
  } else {
    console.log(json)
  }
}
