const { classify } = require('../supportedBranches.js')

function runChecklist({
  committers,
  events,
  files,
  pull_request,
  log,
  maintainers,
  user,
  userIsMaintainer,
}) {
  const allByName = files.every(({ filename }) =>
    filename.startsWith('pkgs/by-name/'),
  )

  const packages = files
    .filter(({ filename }) => filename.startsWith('pkgs/by-name/'))
    .map(({ filename }) => filename.split('/')[3])

  const eligible = !packages.length
    ? new Set()
    : packages
        .map((pkg) => new Set(maintainers[pkg]))
        .reduce((acc, cur) => acc?.intersection(cur) ?? cur)

  const approvals = new Set(
    events
      .filter(
        ({ event, state, commit_id }) =>
          event === 'reviewed' &&
          state === 'approved' &&
          // Only approvals for the current head SHA count, otherwise authors could push
          // bad code between the approval and the merge.
          commit_id === pull_request.head.sha,
      )
      .map(({ user }) => user.id),
  )

  const checklist = {
    'PR targets a [development branch](https://github.com/NixOS/nixpkgs/blob/-/ci/README.md#branch-classification).':
      classify(pull_request.base.ref).type.includes('development'),
    'PR touches only packages in `pkgs/by-name/`.': allByName,
    'PR is at least one of:': {
      'Approved by a committer.': committers.intersection(approvals).size > 0,
      'Authored by a committer.': committers.has(pull_request.user.id),
      'Backported via label.':
        pull_request.user.login === 'nixpkgs-ci[bot]' &&
        pull_request.head.ref.startsWith('backport-'),
      'Created by r-ryantm.': pull_request.user.login === 'r-ryantm',
    },
  }

  if (user) {
    checklist[
      `${user.login} is a member of [@NixOS/nixpkgs-maintainers](https://github.com/orgs/NixOS/teams/nixpkgs-maintainers).`
    ] = userIsMaintainer
    if (allByName) {
      // We can only determine the below, if all packages are in by-name, since
      // we can't reliably relate changed files to packages outside by-name.
      checklist[`${user.login} is a maintainer of all touched packages.`] =
        eligible.has(user.id)
    }
  } else {
    // This is only used when no user is passed, i.e. for labeling.
    checklist['PR has maintainers eligible to merge.'] = eligible.size > 0
  }

  const result = Object.values(checklist).every((v) =>
    typeof v === 'boolean' ? v : Object.values(v).some(Boolean),
  )

  log('checklist', JSON.stringify(checklist))
  log('eligible', JSON.stringify(Array.from(eligible)))
  log('result', result)

  return {
    checklist,
    result,
  }
}

// The merge command must be on a separate line and not within codeblocks or html comments.
// Codeblocks can have any number of ` larger than 3 to open/close. We only look at code
// blocks that are not indented, because the later regex wouldn't match those anyway.
function hasMergeCommand(body) {
  return (body ?? '')
    .replace(/<!--.*?-->/gms, '')
    .replace(/(^`{3,})[^`].*?\1/gms, '')
    .match(/^@NixOS\/nixpkgs-merge-bot merge\s*$/m)
}

async function handleMergeComment({ github, body, node_id, reaction }) {
  if (!hasMergeCommand(body)) return

  await github.graphql(
    `mutation($node_id: ID!, $reaction: ReactionContent!) {
      addReaction(input: {
        content: $reaction,
        subjectId: $node_id
      })
      { clientMutationId }
    }`,
    { node_id, reaction },
  )
}

// Caching the list of team members saves API requests when running the bot on the schedule and
// processing many PRs at once.
const members = {}

async function handleMerge({
  github,
  context,
  core,
  log,
  dry,
  pull_request,
  events,
  maintainers,
}) {
  const pull_number = pull_request.number

  function getTeamMembers(team_slug) {
    if (context.eventName === 'pull_request') {
      // We have no chance of getting a token in the pull_request context with the right
      // permissions to access the members endpoint below. Thus, we're pretending to have
      // no members. This is OK; because this is only for the Test workflow, not for
      // real use.
      return new Set()
    }

    if (!members[team_slug]) {
      members[team_slug] = github
        .paginate(github.rest.teams.listMembersInOrg, {
          org: context.repo.owner,
          team_slug,
          per_page: 100,
        })
        .then((members) => new Set(members.map(({ id }) => id)))
    }

    return members[team_slug]
  }
  const committers = await getTeamMembers('nixpkgs-committers')

  const files = await github.paginate(github.rest.pulls.listFiles, {
    ...context.repo,
    pull_number,
    per_page: 100,
  })

  // Only look through comments *after* the latest (force) push.
  const lastPush = events.findLastIndex(
    ({ event, sha, commit_id }) =>
      ['committed', 'head_ref_force_pushed'].includes(event) &&
      (sha ?? commit_id) === pull_request.head.sha,
  )

  const comments = events.slice(lastPush + 1).filter(
    ({ event, body, node_id }) =>
      ['commented', 'reviewed'].includes(event) &&
      hasMergeCommand(body) &&
      // Ignore comments which had already been responded to by the bot.
      !events.some(
        ({ event, user, body }) =>
          ['commented'].includes(event) &&
          // We're only testing this hidden reference, but not the author of the comment.
          // We'll just assume that nobody creates comments with this marker on purpose.
          // Additionally checking the author is quite annoying for local debugging.
          body.match(new RegExp(`^<!-- comment: ${node_id} -->$`, 'm')),
      ),
  )

  async function merge() {
    if (dry) {
      core.info(`Merging #${pull_number}... (dry)`)
      return 'Merge completed (dry)'
    }

    // Using GraphQL's enablePullRequestAutoMerge mutation instead of the REST
    // /merge endpoint, because the latter doesn't work with Merge Queues.
    // This mutation works both with and without Merge Queues.
    // It doesn't work when there are no required status checks for the target branch.
    // All development branches have these enabled, so this is a non-issue.
    try {
      await github.graphql(
        `mutation($node_id: ID!, $sha: GitObjectID) {
          enablePullRequestAutoMerge(input: {
            expectedHeadOid: $sha,
            pullRequestId: $node_id
          })
          { clientMutationId }
        }`,
        { node_id: pull_request.node_id, sha: pull_request.head.sha },
      )
      return 'Enabled Auto Merge'
    } catch (e) {
      log('Auto Merge failed', e.response.errors[0].message)
    }

    // TODO: Observe whether the below is true and whether manual enqueue is actually needed.
    // Auto-merge doesn't work if the target branch has already run all CI, in which
    // case the PR must be enqueued explicitly.
    // We now have merge queues enabled on all development branches, thus don't need a
    // fallback after this.
    try {
      const resp = await github.graphql(
        `mutation($node_id: ID!, $sha: GitObjectID) {
          enqueuePullRequest(input: {
            expectedHeadOid: $sha,
            pullRequestId: $node_id
          })
          {
            clientMutationId,
            mergeQueueEntry { mergeQueue { url } }
          }
        }`,
        { node_id: pull_request.node_id, sha: pull_request.head.sha },
      )
      return `[Queued](${resp.enqueuePullRequest.mergeQueueEntry.mergeQueue.url}) for merge`
    } catch (e) {
      log('Enqueing failed', e.response.errors[0].message)
      throw new Error(e.response.errors[0].message)
    }
  }

  for (const comment of comments) {
    log('comment', comment.node_id)

    async function react(reaction) {
      if (dry) {
        core.info(`Reaction ${reaction} on ${comment.node_id} (dry)`)
        return
      }

      await handleMergeComment({
        github,
        body: comment.body,
        node_id: comment.node_id,
        reaction,
      })
    }

    async function isMaintainer(username) {
      try {
        return (
          (
            await github.rest.teams.getMembershipForUserInOrg({
              org: context.repo.owner,
              team_slug: 'nixpkgs-maintainers',
              username,
            })
          ).data.state === 'active'
        )
      } catch (e) {
        if (e.status === 404) return false
        else throw e
      }
    }

    const { result, checklist } = runChecklist({
      committers,
      events,
      files,
      pull_request,
      log,
      maintainers,
      user: comment.user,
      userIsMaintainer: await isMaintainer(comment.user.login),
    })

    const body = [
      `<!-- comment: ${comment.node_id} -->`,
      `@${comment.user.login} wants to merge this PR.`,
      '',
      'Requirements to merge this PR with `@NixOS/nixpkgs-merge-bot merge`:',
      ...Object.entries(checklist).flatMap(([msg, res]) =>
        typeof res === 'boolean'
          ? `- :${res ? 'white_check_mark' : 'x'}: ${msg}`
          : [
              `- :${Object.values(res).some(Boolean) ? 'white_check_mark' : 'x'}: ${msg}`,
              ...Object.entries(res).map(
                ([msg, res]) =>
                  `  - ${res ? ':white_check_mark:' : ':white_large_square:'} ${msg}`,
              ),
            ],
      ),
      '',
    ]

    if (result) {
      await react('ROCKET')
      try {
        body.push(`:heavy_check_mark: ${await merge()} (#306934)`)
      } catch (e) {
        // Remove the HTML comment with node_id reference to allow retrying this merge on the next run.
        body.shift()
        body.push(`:x: Merge failed with: ${e} (#371492)`)
      }
    } else {
      await react('THUMBS_DOWN')
      body.push(':x: Pull Request could not be merged (#305350)')
    }

    if (dry) {
      core.info(body.join('\n'))
    } else {
      await github.rest.issues.createComment({
        ...context.repo,
        issue_number: pull_number,
        body: body.join('\n'),
      })
    }

    if (result) break
  }

  const { result } = runChecklist({
    committers,
    events,
    files,
    pull_request,
    log,
    maintainers,
  })

  // Returns a boolean, which indicates whether the PR is merge-bot eligible in principle.
  // This is used to set the respective label in bot.js.
  return result
}

module.exports = {
  handleMerge,
  handleMergeComment,
}
