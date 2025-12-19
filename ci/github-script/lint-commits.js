// @ts-check
const { classify } = require('../supportedBranches.js')

/**
 * @param {{
 *  github: InstanceType<import('@actions/github/lib/utils').GitHub>,
 *  context: import('@actions/github/lib/context').Context
 *  core: import('@actions/core')
 * }} CheckCommitMessagesProps
 */
async function checkCommitMessages({ github, context, core }) {
  // This check should only be run when we have the pull_request context.
  const pull_number = context.payload.pull_request?.number
  if (!pull_number) {
    core.info('This is not a pull request. Skipping checks.')
    return
  }

  const pr = (
    await github.rest.pulls.get({
      ...context.repo,
      pull_number,
    })
  ).data

  const baseBranchType = classify(
    pr.base.ref.replace(/^refs\/heads\//, ''),
  ).type
  const headBranchType = classify(
    pr.head.ref.replace(/^refs\/heads\//, ''),
  ).type

  if (
    baseBranchType.includes('development') &&
    headBranchType.includes('development')
  ) {
    // This matches, for example, PRs from staging-next to master, or vice versa.
    // Ignore them: we should only care about PRs introducing *new* commits.
    core.info(
      'This PR is from one development branch to another. Skipping checks.',
    )
    return
  }

  const commits = await github.paginate(github.rest.pulls.listCommits, {
    ...context.repo,
    pull_number,
  })

  const failures = new Set()

  for (const commit of commits) {
    const message = commit.commit.message
    const firstLine = message.split('\n')[0]

    const logMsgStart = `Commit ${commit.sha}'s message's subject ("${firstLine}")`

    if (!firstLine.includes(':')) {
      core.error(
        `${logMsgStart} was detected as not meeting our guidelines because ` +
          'it does not contain a colon. There are likely other issues as well.',
      )
      failures.add(commit.sha)
    }

    if (firstLine.endsWith('.')) {
      core.error(
        `${logMsgStart} was detected as not meeting our guidelines because ` +
          'it ends in a period. There may be other issues as well.',
      )
      failures.add(commit.sha)
    }

    if (!failures.has(commit.sha)) {
      core.info(`${logMsgStart} passed our automated checks!`)
    }
  }

  if (failures.size !== 0) {
    core.error(
      'Please review the guidelines at ' +
        'https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#commit-conventions, ' +
        'as well as the applicable area-specific guidelines linked there.',
    )
    core.setFailed('Committers: merging is discouraged.')
  }
}

module.exports = checkCommitMessages
