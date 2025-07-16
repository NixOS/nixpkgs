module.exports = async function ({ github, context, core, dry }) {
  const { execFileSync } = require('node:child_process')
  const { readFile } = require('node:fs/promises')
  const { join } = require('node:path')
  const { classify } = require('../supportedBranches.js')
  const withRateLimit = require('./withRateLimit.js')

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
      ).find(({ name }) => name == 'Check / cherry-pick').html_url +
        '?pr=' +
        pull_number

    async function handle({ sha, commit }) {
      // Using the last line with "cherry" + hash, because a chained backport
      // can result in multiple of those lines. Only the last one counts.
      const match = Array.from(
        commit.message.matchAll(/cherry.*([0-9a-f]{40})/g),
      ).at(-1)

      if (!match)
        return {
          sha,
          commit,
          severity: 'warning',
          message: `Couldn't locate original commit hash in message of ${sha}.`,
        }

      const original_sha = match[1]

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
      }
    }

    const commits = await github.paginate(github.rest.pulls.listCommits, {
      ...context.repo,
      pull_number,
    })

    const results = await Promise.all(commits.map(handle))

    // Log all results without truncation, with better highlighting and all whitespace changes to the job log.
    results.forEach(({ sha, commit, severity, message, colored_diff }) => {
      core.startGroup(`Commit ${sha}`)
      core.info(`Author: ${commit.author.name} ${commit.author.email}`)
      core.info(`Date: ${new Date(commit.author.date)}`)
      core[severity](message)
      core.endGroup()
      if (colored_diff) core.info(colored_diff)
    })

    // Only create step summary below in case of warnings or errors.
    // Also clean up older reviews, when all checks are good now.
    if (results.every(({ severity }) => severity == 'info')) {
      if (!dry) {
        await Promise.all(
          (
            await github.paginate(github.rest.pulls.listReviews, {
              ...context.repo,
              pull_number,
            })
          )
            .filter((review) => review.user.login == 'github-actions[bot]')
            .map(async (review) => {
              if (review.state == 'CHANGES_REQUESTED') {
                await github.rest.pulls.dismissReview({
                  ...context.repo,
                  pull_number,
                  review_id: review.id,
                  message: 'All cherry-picks are good now, thank you!',
                })
              }
              await github.graphql(
                `mutation($node_id:ID!) {
                  minimizeComment(input: {
                    classifier: RESOLVED,
                    subjectId: $node_id
                  })
                  { clientMutationId }
                }`,
                { node_id: review.node_id },
              )
            }),
        )
      }
      return
    }

    // In the case of "error" severity, we also fail the job.
    // Those should be considered blocking and not be dismissable via review.
    if (results.some(({ severity }) => severity == 'error'))
      process.exitCode = 1

    core.summary.addRaw(
      await readFile(join(__dirname, 'check-cherry-picks.md'), 'utf-8'),
      true,
    )
    results.forEach(({ severity, message, diff }) => {
      if (severity == 'info') return

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
        `\n\n[!${severity == 'warning' ? 'WARNING' : 'CAUTION'}]`,
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
        core.summary.addCodeBlock(
          truncated
            .join('\n')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;'),
          'diff',
        )
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

    const pendingReview = (
      await github.paginate(github.rest.pulls.listReviews, {
        ...context.repo,
        pull_number,
      })
    ).find(
      (review) =>
        review.user.login == 'github-actions[bot]' &&
        // If a review is still pending, we can just update this instead
        // of posting a new one.
        (review.state == 'CHANGES_REQUESTED' ||
          // No need to post a new review, if an older one with the exact
          // same content had already been dismissed.
          review.body == body),
    )

    if (dry) {
      if (pendingReview)
        core.info('pending review found: ' + pendingReview.html_url)
      else core.info('no pending review found')
    } else {
      // Either of those two requests could fail for very long comments. This can only happen
      // with multiple commits all hitting the truncation limit for the diff. If you ever hit
      // this case, consider just splitting up those commits into multiple PRs.
      if (pendingReview) {
        await github.rest.pulls.updateReview({
          ...context.repo,
          pull_number,
          review_id: pendingReview.id,
          body,
        })
      } else {
        await github.rest.pulls.createReview({
          ...context.repo,
          pull_number,
          event: 'REQUEST_CHANGES',
          body,
        })
      }
    }
  })
}
