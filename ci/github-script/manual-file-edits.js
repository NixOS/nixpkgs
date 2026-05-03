// @ts-check
const { getCommitDetailsForPR } = require('./get-pr-commit-details')

/**
 * @param {{
 *  github: InstanceType<import('@actions/github/lib/utils').GitHub>,
 *  context: import('@actions/github/lib/context').Context,
 *  core: import('@actions/core'),
 *  repoPath?: string,
 * }} CheckManualFileEditsProps
 */
async function checkManualFileEdits({ github, context, core, repoPath }) {
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

  if (pr.user.login.endsWith('[bot]')) {
    core.info('This is a bot, so these checks do not apply.')
    return
  }

  const details = await getCommitDetailsForPR({ core, pr, repoPath })

  if (
    details.some(({ changedPaths }) =>
      changedPaths.includes('maintainers/github-teams.json'),
    )
  ) {
    core.setFailed(
      [
        'maintainers/github-teams.json is supposed to accurately reflect the state of the teams in GitHub.\n',
        'Therefore, it should not be edited manually.\n',
        'All changes to teams listed in maintainers/github-teams.json should be performed in GitHub by a team maintainer.\n',
        "Team maintainers are listed in the github-teams.json file and in GitHub's UI.\n",
        'If there is no team maintainer available, an org owner can make the needed change, please contact one by',
        'following the instructions at https://github.com/NixOS/org/blob/main/doc/github-org-owners.md#how-to-contact-the-team.\n',
        'Thank you!',
      ].reduce(
        (prev, curr) => prev + (!prev || prev.endsWith('\n') ? '' : ' ') + curr,
        '',
      ),
    )
  }
}

module.exports = checkManualFileEdits
