// @ts-check
const { classify } = require('../supportedBranches.js')
const { getCommitDetailsForPR } = require('./get-pr-commit-details')

/**
 * @param {{
 *  github: InstanceType<import('@actions/github/lib/utils').GitHub>,
 *  context: import('@actions/github/lib/context').Context,
 *  core: import('@actions/core'),
 *  repoPath?: string,
 *  dry: boolean,
 * }} CheckManualFileEditsProps
 */
async function checkManualFileEdits({ github, context, core, repoPath, dry }) {
  const { dismissReviews, postReview } = require('./reviews.js')
  const reviewKey = 'manual-file-edits'

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

  const baseBranchType = classify(
    pr.base.ref.replace(/^refs\/heads\//, ''),
  ).type
  const headBranchType = classify(
    pr.head.ref.replace(/^refs\/heads\//, ''),
  ).type

  if (
    baseBranchType.includes('development') &&
    headBranchType.includes('development') &&
    pr.base.repo.id === pr.head.repo?.id
  ) {
    // This matches, for example, PRs from NixOS:staging-next to NixOS:master, or vice versa.
    // Ignore them: we should only care about PRs introducing *new* commits.
    // We still want to run on PRs from, e.g., Someone:master to NixOS:master, though.
    core.info(
      'This PR is from one development branch to another. Skipping checks.',
    )
    return
  }

  const details = await getCommitDetailsForPR({ core, pr, repoPath })

  if (
    details.some(({ changedPaths }) =>
      changedPaths.includes('maintainers/github-teams.json'),
    )
  ) {
    postReview({
      github,
      context,
      core,
      dry,
      event: 'REQUEST_CHANGES',
      body: [
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
      reviewKey,
    })
  } else {
    dismissReviews({
      github,
      context,
      core,
      dry,
      reviewKey,
    })
  }
}

module.exports = checkManualFileEdits
