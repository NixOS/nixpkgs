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

    if (headClassification.type.includes('wip')) {
      // In the following, we look at the git history to determine the base branch that
      // this Pull Request branched off of. This is *supposed* to be the branch that it
      // merges into, but humans make mistakes. Once that happens we want to error out as
      // early as possible.

      // To determine the "real base", we are looking at the merge-base of primary development
      // branches and the head of the PR. The merge-base which results in the least number of
      // commits between that base and head is the real base. We can query for this via GitHub's
      // REST API. There can be multiple candidates for the real base with the same number of
      // commits. In this case we pick the "best" candidate by a fixed ordering of branches,
      // as defined in ci/supportedBranches.js.
      //
      // These requests take a while, when comparing against the wrong release - they need
      // to look at way more than 10k commits in that case. Thus, we try to minimize the
      // number of requests across releases:
      // - First, we look at the primary development branches only: master and release-xx.yy.
      //   The branch with the fewest commits gives us the release this PR belongs to.
      // - We then compare this number against the relevant staging branches for this release
      //   to find the exact branch that this belongs to.

      // All potential development branches
      const branches = (
        await github.paginate(github.rest.repos.listBranches, {
          ...context.repo,
          per_page: 100,
        })
      ).map(({ name }) => classify(name))

      // All stable primary development branches from latest to oldest.
      const releases = branches
        .filter(({ stable, type }) => type.includes('primary') && stable)
        .sort((a, b) => b.version.localeCompare(a.version))

      async function mergeBase({ branch, order, version }) {
        const { data } = await github.rest.repos.compareCommitsWithBasehead({
          ...context.repo,
          basehead: `${branch}...${head.sha}`,
          // Pagination for this endpoint is about the commits listed, which we don't care about.
          per_page: 1,
          // Taking the second page skips the list of files of this changeset.
          page: 2,
        })
        return {
          branch,
          order,
          version,
          commits: data.total_commits,
          sha: data.merge_base_commit.sha,
        }
      }

      // Multiple branches can be OK at the same time, if the PR was created of a merge-base,
      // thus storing as array.
      let candidates = [await mergeBase(classify('master'))]
      for (const release of releases) {
        const nextCandidate = await mergeBase(release)
        if (candidates[0].commits === nextCandidate.commits)
          candidates.push(nextCandidate)
        if (candidates[0].commits > nextCandidate.commits)
          candidates = [nextCandidate]
        // The number 10000 is principally arbitrary, but the GitHub API returns this value
        // when the number of commits exceeds it in reality. The difference between two stable releases
        // is certainly more than 10k commits, thus this works for us as well: If we're targeting
        // a wrong release, the number *will* be 10000.
        if (candidates[0].commits < 10000) break
      }

      core.info(`This PR is for NixOS ${candidates[0].version}.`)

      // Secondary development branches for the selected version only.
      const secondary = branches.filter(
        ({ branch, type, version }) =>
          type.includes('secondary') && version === candidates[0].version,
      )

      // Make sure that we always check the current target as well, even if its a WIP branch.
      secondary.push(classify(base.ref))

      for (const branch of secondary) {
        const nextCandidate = await mergeBase(branch)
        if (candidates[0].commits === nextCandidate.commits)
          candidates.push(nextCandidate)
        if (candidates[0].commits > nextCandidate.commits)
          candidates = [nextCandidate]
      }

      // If the current branch is among the candidates, this is always better than any other,
      // thus sorting at -1.
      candidates = candidates
        .map((candidate) =>
          candidate.branch === base.ref
            ? { ...candidate, order: -1 }
            : candidate,
        )
        .sort((a, b) => a.order - b.order)

      const best = candidates.at(0)

      core.info('The base branches for this PR are:')
      core.info(`github: ${base.ref}`)
      core.info(
        `candidates: ${candidates.map(({ branch }) => branch).join(',')}`,
      )
      core.info(`best candidate: ${best.branch}`)

      if (best.branch !== base.ref) {
        const current = await mergeBase(classify(base.ref))
        const body = [
          `The PR's base branch is set to \`${current.branch}\`, but ${current.commits === 10000 ? 'at least 10000' : current.commits - best.commits} commits from the \`${best.branch}\` branch are included. Make sure you know the [right base branch for your changes](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#branch-conventions), then:`,
          `- If the changes should go to the \`${best.branch}\` branch, [change the base branch](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/changing-the-base-branch-of-a-pull-request).`,
          `- If the changes should go to the \`${current.branch}\` branch, rebase your PR onto the correct merge-base:`,
          '  ```bash',
          `  # git rebase --onto $(git merge-base upstream/${current.branch} HEAD) $(git merge-base upstream/${best.branch} HEAD)`,
          `  git rebase --onto ${current.sha} ${best.sha}`,
          `  git push --force-with-lease`,
          '  ```',
        ].join('\n')

        await postReview({ github, context, core, dry, body })

        throw new Error(`The PR contains commits from a different base.`)
      }
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

      mergedSha = head.sha
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

    const touched = []
    if (files.includes('ci/pinned.json')) touched.push('pinned')
    core.setOutput('touched', touched)

    return
  }
  throw new Error(
    "Not retrying anymore. It's likely that GitHub is having internal issues: check https://www.githubstatus.com.",
  )
}
