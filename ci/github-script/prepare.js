const { classify } = require('../supportedBranches.js')
const { postReview } = require('./reviews.js')

module.exports = async ({ github, context, core, dry }) => {
  const pull_number = context.payload.pull_request.number

  for (const retryInterval of [5, 10, 20, 40, 80]) {
    core.info('Checking whether the pull request can be merged...')
    const prInfo = (
      await github.rest.pulls.get({
        ...context.repo,
        pull_number,
      })
    ).data

    if (prInfo.state !== 'open') throw new Error('PR is not open anymore.')

    if (prInfo.mergeable == null) {
      core.info(
        `GitHub is still computing whether this PR can be merged, waiting ${retryInterval} seconds before trying again...`,
      )
      await new Promise((resolve) => setTimeout(resolve, retryInterval * 1000))
      continue
    }

    const { base, head } = prInfo

    const baseClassification = classify(base.ref)
    core.setOutput('base', baseClassification)
    console.log('base classification:', baseClassification)

    const headClassification =
      base.repo.full_name === head.repo.full_name
        ? classify(head.ref)
        : // PRs from forks are always considered WIP.
          { type: ['wip'] }
    core.setOutput('head', headClassification)
    console.log('head classification:', headClassification)

    if (baseClassification.type.includes('channel')) {
      const { stable, version } = baseClassification
      const correctBranch = stable ? `release-${version}` : 'master'
      const body = [
        'The `nixos-*` and `nixpkgs-*` branches are pushed to by the channel release script and should not be merged into directly.',
        '',
        `Please target \`${correctBranch}\` instead.`,
      ].join('\n')

      await postReview({ github, context, core, dry, body })

      throw new Error('The PR targets a channel branch.')
    }

    let mergedSha, targetSha

    if (prInfo.mergeable) {
      core.info('The PR can be merged.')

      mergedSha = prInfo.merge_commit_sha
      targetSha = (
        await github.rest.repos.getCommit({
          ...context.repo,
          ref: prInfo.merge_commit_sha,
        })
      ).data.parents[0].sha
    } else {
      core.warning('The PR has a merge conflict.')

      mergedSha = prInfo.head.sha
      targetSha = (
        await github.rest.repos.compareCommitsWithBasehead({
          ...context.repo,
          basehead: `${base.sha}...${head.sha}`,
        })
      ).data.merge_base_commit.sha
    }

    core.info(
      `Checking the commits:\nmerged: ${mergedSha}\ntarget: ${targetSha}`,
    )
    core.setOutput('mergedSha', mergedSha)
    core.setOutput('targetSha', targetSha)

    core.setOutput('systems', require('../supportedSystems.json'))

    const files = (
      await github.paginate(github.rest.pulls.listFiles, {
        ...context.repo,
        pull_number: context.payload.pull_request.number,
        per_page: 100,
      })
    ).map((file) => file.filename)

    if (files.includes('ci/pinned.json')) core.setOutput('touched', ['pinned'])
    else core.setOutput('touched', [])

    return
  }
  throw new Error(
    "Not retrying anymore. It's likely that GitHub is having internal issues: check https://www.githubstatus.com.",
  )
}
