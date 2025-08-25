const { classify } = require('../supportedBranches.js')

module.exports = async ({ github, context, core }) => {
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

    const files = (
      await github.paginate(github.rest.pulls.listFiles, {
        ...context.repo,
        pull_number: context.payload.pull_request.number,
        per_page: 100,
      })
    ).map((file) => file.filename)

    const touched = []
    if (files.includes('ci/pinned.json')) touched.push('pinned')
    if (files.includes('ci/OWNERS')) touched.push('owners')
    core.setOutput('touched', touched)

    return
  }
  throw new Error(
    "Not retrying anymore. It's likely that GitHub is having internal issues: check https://www.githubstatus.com.",
  )
}
