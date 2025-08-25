module.exports = async ({ github, context, core, dry, cherryPicks }) => {
  const { execFileSync } = require('node:child_process')
  const { classify } = require('../supportedBranches.js')
  const withRateLimit = require('./withRateLimit.js')
  const { dismissReviews, postReview } = require('./reviews.js')

  await withRateLimit({ github, core }, async (stats) => {
    stats.prs = 1

    const pull_number = context.payload.pull_request.number

    const job_url =
      context.runId &&
      (
        await github.paginate(github.rest.actions.listJobsForWorkflowRun, {
          ...context.repo,
          run_id: context.runId,
          per_page: 100,
        })
      ).find(({ name }) => name.endsWith('Check / commits')).html_url +
        '?pr=' +
        pull_number

    async function extract({ sha, commit }) {
      const noCherryPick = Array.from(
        commit.message.matchAll(/^Not-cherry-picked-because: (.*)$/gm),
      ).at(0)

      if (noCherryPick)
        return {
          sha,
          commit,
          severity: 'important',
          message: `${sha} is not a cherry-pick, because: ${noCherryPick[1]}. Please review this commit manually.`,
          type: 'no-cherry-pick',
        }

      // Using the last line with "cherry" + hash, because a chained backport
      // can result in multiple of those lines. Only the last one counts.
      const cherry = Array.from(
        commit.message.matchAll(/cherry.*([0-9a-f]{40})/g),
      ).at(-1)

      if (!cherry)
        return {
          sha,
          commit,
          severity: 'warning',
          message: `Couldn't locate original commit hash in message of ${sha}.`,
          type: 'no-commit-hash',
        }

      const original_sha = cherry[1]

      let branches
      try {
        branches = (
          await github.request({
            // This is an undocumented endpoint to fetch the branches a commit is part of.
            // There is no equivalent in neither the REST nor the GraphQL API.
            // The endpoint itself is unlikely to go away, because GitHub uses it to display
            // the list of branches on the detail page of a commit.
            url: `https://github.com/${context.repo.owner}/${context.repo.repo}/branch_commits/${original_sha}`,
            headers: {
              accept: 'application/json',
            },
          })
        ).data.branches
          .map(({ branch }) => branch)
          .filter((branch) => classify(branch).type.includes('development'))
      } catch (e) {
        // For some unknown reason a 404 error comes back as 500 without any more details in a GitHub Actions runner.
        // Ignore these to return a regular error message below.
        if (![404, 500].includes(e.status)) throw e
      }
      if (!branches?.length)
        return {
          sha,
          commit,
          severity: 'error',
          message: `${original_sha} given in ${sha} not found in any pickable branch.`,
        }

      return {
        sha,
        commit,
        original_sha,
      }
    }

    function diff({ sha, commit, original_sha }) {
      const diff = execFileSync('git', [
        '-C',
        __dirname,
        'range-diff',
        '--no-color',
        '--ignore-all-space',
        '--no-notes',
        // 100 means "any change will be reported"; 0 means "no change will be reported"
        '--creation-factor=100',
        `${original_sha}~..${original_sha}`,
        `${sha}~..${sha}`,
      ])
        .toString()
        .split('\n')
        // First line contains commit SHAs, which we'll print separately.
        .slice(1)
        // # The output of `git range-diff` is indented with 4 spaces, but we'll control indentation manually.
        .map((line) => line.replace(/^ {4}/, ''))

      if (!diff.some((line) => line.match(/^[+-]{2}/)))
        return {
          sha,
          commit,
          severity: 'info',
          message: `✔ ${original_sha} is highly similar to ${sha}.`,
        }

      const colored_diff = execFileSync('git', [
        '-C',
        __dirname,
        'range-diff',
        '--color',
        '--no-notes',
        '--creation-factor=100',
        `${original_sha}~..${original_sha}`,
        `${sha}~..${sha}`,
      ]).toString()

      return {
        sha,
        commit,
        diff,
        colored_diff,
        severity: 'warning',
        message: `Difference between ${sha} and original ${original_sha} may warrant inspection.`,
        type: 'diff',
      }
    }

    // For now we short-circuit the list of commits when cherryPicks should not be checked.
    // This will not run any checks, but still trigger the "dismiss reviews" part below.
    const commits = !cherryPicks
      ? []
      : await github.paginate(github.rest.pulls.listCommits, {
          ...context.repo,
          pull_number,
        })

    const extracted = await Promise.all(commits.map(extract))

    const fetch = extracted
      .filter(({ severity }) => !severity)
      .flatMap(({ sha, original_sha }) => [sha, original_sha])

    if (fetch.length > 0) {
      // Fetching all commits we need for diff at once is much faster than any other method.
      execFileSync('git', [
        '-C',
        __dirname,
        'fetch',
        '--depth=2',
        'origin',
        ...fetch,
      ])
    }

    const results = extracted.map((result) =>
      result.severity ? result : diff(result),
    )

    // Log all results without truncation, with better highlighting and all whitespace changes to the job log.
    results.forEach(({ sha, commit, severity, message, colored_diff }) => {
      core.startGroup(`Commit ${sha}`)
      core.info(`Author: ${commit.author.name} ${commit.author.email}`)
      core.info(`Date: ${new Date(commit.author.date)}`)
      switch (severity) {
        case 'error':
          core.error(message)
          break
        case 'warning':
          core.warning(message)
          break
        default:
          core.info(message)
      }
      core.endGroup()
      if (colored_diff) core.info(colored_diff)
    })

    // Only create step summary below in case of warnings or errors.
    // Also clean up older reviews, when all checks are good now.
    // An empty results array will always trigger this condition, which is helpful
    // to clean up reviews created by the prepare step when on the wrong branch.
    if (results.every(({ severity }) => severity === 'info')) {
      await dismissReviews({ github, context, dry })
      return
    }

    // In the case of "error" severity, we also fail the job.
    // Those should be considered blocking and not be dismissable via review.
    if (results.some(({ severity }) => severity === 'error'))
      process.exitCode = 1

    core.summary.addRaw(
      'This report is automatically generated by the `PR / Check / cherry-pick` CI workflow.',
      true,
    )
    core.summary.addEOL()
    core.summary.addRaw(
      "Some of the commits in this PR require the author's and reviewer's attention.",
      true,
    )
    core.summary.addEOL()

    if (results.some(({ type }) => type === 'no-commit-hash')) {
      core.summary.addRaw(
        'Please follow the [backporting guidelines](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#how-to-backport-pull-requests) and cherry-pick with the `-x` flag.',
        true,
      )
      core.summary.addRaw(
        'This requires changes to the unstable `master` and `staging` branches first, before backporting them.',
        true,
      )
      core.summary.addEOL()
      core.summary.addRaw(
        'Occasionally, commits are not cherry-picked at all, for example when updating minor versions of packages which have already advanced to the next major on unstable.',
        true,
      )
      core.summary.addRaw(
        'These commits can optionally be marked with a `Not-cherry-picked-because: <reason>` footer.',
        true,
      )
      core.summary.addEOL()
    }

    if (results.some(({ type }) => type === 'diff')) {
      core.summary.addRaw(
        'Sometimes it is not possible to cherry-pick exactly the same patch.',
        true,
      )
      core.summary.addRaw(
        'This most frequently happens when resolving merge conflicts.',
        true,
      )
      core.summary.addRaw(
        'The range-diff will help to review the resolution of conflicts.',
        true,
      )
      core.summary.addEOL()
    }

    core.summary.addRaw(
      'If you need to merge this PR despite the warnings, please [dismiss](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/dismissing-a-pull-request-review) this review shortly before merging.',
      true,
    )

    results.forEach(({ severity, message, diff }) => {
      if (severity === 'info') return

      // The docs for markdown alerts only show examples with markdown blockquote syntax, like this:
      //   > [!WARNING]
      //   > message
      // However, our testing shows that this also works with a `<blockquote>` html tag, as long as there
      // is an empty line:
      //   <blockquote>
      //
      //   [!WARNING]
      //   message
      //   </blockquote>
      // Whether this is intended or just an implementation detail is unclear.
      core.summary.addRaw('<blockquote>')
      core.summary.addRaw(
        `\n\n[!${{ important: 'IMPORTANT', warning: 'WARNING', error: 'CAUTION' }[severity]}]`,
        true,
      )
      core.summary.addRaw(`${message}`, true)

      if (diff) {
        // Limit the output to 10k bytes and remove the last, potentially incomplete line, because GitHub
        // comments are limited in length. The value of 10k is arbitrary with the assumption, that after
        // the range-diff becomes a certain size, a reviewer is better off reviewing the regular diff in
        // GitHub's UI anyway, thus treating the commit as "new" and not cherry-picked.
        // Note: if multiple commits are close to the limit, this approach could still lead to a comment
        // that's too long. We think this is unlikely to happen, and so don't deal with it explicitly.
        const truncated = []
        let total_length = 0
        for (line of diff) {
          total_length += line.length
          if (total_length > 10000) {
            truncated.push('', '[...truncated...]')
            break
          } else {
            truncated.push(line)
          }
        }

        core.summary.addRaw('<details><summary>Show diff</summary>')
        core.summary.addRaw('\n\n``````````diff', true)
        core.summary.addRaw(truncated.join('\n'), true)
        core.summary.addRaw('``````````', true)
        core.summary.addRaw('</details>')
      }

      core.summary.addRaw('</blockquote>')
    })

    if (job_url)
      core.summary.addRaw(
        `\n\n_Hint: The full diffs are also available in the [runner logs](${job_url}) with slightly better highlighting._`,
      )

    const body = core.summary.stringify()
    core.summary.write()

    // Posting a review could fail for very long comments. This can only happen with
    // multiple commits all hitting the truncation limit for the diff. If you ever hit
    // this case, consider just splitting up those commits into multiple PRs.
    await postReview({ github, context, core, dry, body })
  })
}
