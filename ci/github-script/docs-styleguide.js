import { getCommitDetailsForPR } from './get-pr-commit-details.js'
import { dismissReviews, postReview } from './reviews.js'
import { classify } from './supportedBranches.js'

/**
 * @param {{
 *  github: InstanceType<typeof import('@actions/github/lib/utils').GitHub>,
 *  context: typeof import('@actions/github').context,
 *  core: typeof import('@actions/core'),
 *  repoPath?: string,
 *  dry: boolean,
 * }} CheckDocsStyleguideProps
 */
export async function checkDocsStyleguide({
  github,
  context,
  core,
  repoPath,
  dry,
}) {
  const reviewKey = 'docs-styleguide'

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

  /** @param {string} path */
  const isDocsPath = (path) =>
    path.startsWith('doc/') ||
    path.startsWith('nixos/doc/') ||
    (path.startsWith('nixos/modules/') && path.endsWith('.md'))

  if (details.some(({ changedPaths }) => changedPaths.some(isDocsPath))) {
    await postReview({
      github,
      context,
      core,
      dry,
      event: 'COMMENT',
      body: [
        'Thanks for contributing to the documentation',
        '',
        'Make sure you follow the [documentation styleguide](https://github.com/NixOS/nixpkgs/blob/master/doc/styleguide.md), most notably:',
        '',
        "- **Show, don't tell**: lead with a minimal working example; explanation follows the code.",
        '- **No meta-commentary**: don\'t write "This section explains how to…", just do it.',
        '- **Imperative mood and active voice**: "Run the command", not "The user should run the following command".',
        '- **Present tense**: "This creates a folder", not "This will create a folder".',
        '- **Be confident**: no hedging with "should", "might", "typically", "usually".',
        '- **Cut filler words**: "simply", "just", "easily", "basically"; "to", not "in order to".',
        '',
        'For larger changes, like adding or removing whole sections, ask the NixOS documentation team for a review.',
      ].join('\n'),
      reviewKey,
    })
  } else {
    await dismissReviews({
      github,
      context,
      core,
      dry,
      reviewKey,
    })
  }
}
