module.exports = async function ({ github, context, core }) {
  const { execFileSync } = require('node:child_process')
  const { readFile, writeFile } = require('node:fs/promises')
  const { join } = require('node:path')
  const { classify } = require('../supportedBranches.js')
  const withRateLimit = require('./withRateLimit.js')

  await withRateLimit({ github, core }, async (stats) => {
    stats.prs = 1

    const job_url =
      context.runId &&
      (
        await github.rest.actions.listJobsForWorkflowRun({
          ...context.repo,
          run_id: context.runId,
        })
      ).data.jobs[0].html_url +
        '?pr=' +
        context.payload.pull_request.number

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
      pull_number: context.payload.pull_request.number,
    })

    const results = await Promise.all(commits.map(handle))

    // Log all results without truncation and with better highlighting to the job log.
    results.forEach(({ sha, commit, severity, message, colored_diff }) => {
      core.startGroup(`Commit ${sha}`)
      core.info(`Author: ${commit.author.name} ${commit.author.email}`)
      core.info(`Date: ${new Date(commit.author.date)}`)
      core[severity](message)
      core.endGroup()
      if (colored_diff) core.info(colored_diff)
    })

    // Only create step summary below in case of warnings or errors.
    if (results.every(({ severity }) => severity == 'info')) return
    else process.exitCode = 1

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
        core.summary.addRaw('\n\n```diff', true)
        core.summary.addRaw(truncated.join('\n'), true)
        core.summary.addRaw('```', true)
        core.summary.addRaw('</details>')
      }

      core.summary.addRaw('</blockquote>')
    })

    if (job_url)
      core.summary.addRaw(
        `\n\n_Hint: The full diffs are also available in the [runner logs](${job_url}) with slightly better highlighting._`,
      )

    // Write to disk temporarily for next step in GHA.
    await writeFile('review.md', core.summary.stringify())

    core.summary.write()
  })
}
