module.exports = async ({ github, context, core, dry }) => {
  const path = require('node:path')
  const { DefaultArtifactClient } = require('@actions/artifact')
  const { readFile, writeFile } = require('node:fs/promises')
  const withRateLimit = require('./withRateLimit.js')

  const artifactClient = new DefaultArtifactClient()

  async function handlePullRequest({ item, stats }) {
    const log = (k, v) => core.info(`PR #${item.number} - ${k}: ${v}`)

    const pull_number = item.number

    // This API request is important for the merge-conflict label, because it triggers the
    // creation of a new test merge commit. This is needed to actually determine the state of a PR.
    const pull_request = (
      await github.rest.pulls.get({
        ...context.repo,
        pull_number,
      })
    ).data

    const reviews = await github.paginate(github.rest.pulls.listReviews, {
      ...context.repo,
      pull_number,
    })

    const approvals = new Set(
      reviews
        .filter((review) => review.state === 'APPROVED')
        .map((review) => review.user?.id),
    )

    // After creation of a Pull Request, `merge_commit_sha` will be null initially:
    // The very first merge commit will only be calculated after a little while.
    // To avoid labeling the PR as conflicted before that, we wait a few minutes.
    // This is intentionally less than the time that Eval takes, so that the label job
    // running after Eval can indeed label the PR as conflicted if that is the case.
    const merge_commit_sha_valid =
      Date.now() - new Date(pull_request.created_at) > 3 * 60 * 1000

    const prLabels = {
      // We intentionally don't use the mergeable or mergeable_state attributes.
      // Those have an intermediate state while the test merge commit is created.
      // This doesn't work well for us, because we might have just triggered another
      // test merge commit creation by request the pull request via API at the start
      // of this function.
      // The attribute merge_commit_sha keeps the old value of null or the hash *until*
      // the new test merge commit has either successfully been created or failed so.
      // This essentially means we are updating the merge conflict label in two steps:
      // On the first pass of the day, we just fetch the pull request, which triggers
      // the creation. At this stage, the label is likely not updated, yet.
      // The second pass will then read the result from the first pass and set the label.
      '2.status: merge conflict':
        merge_commit_sha_valid && !pull_request.merge_commit_sha,
      '12.approvals: 1': approvals.size === 1,
      '12.approvals: 2': approvals.size === 2,
      '12.approvals: 3+': approvals.size >= 3,
      '12.first-time contribution': [
        'NONE',
        'FIRST_TIMER',
        'FIRST_TIME_CONTRIBUTOR',
      ].includes(pull_request.author_association),
    }

    const { id: run_id, conclusion } =
      (
        await github.rest.actions.listWorkflowRuns({
          ...context.repo,
          workflow_id: 'pr.yml',
          event: 'pull_request_target',
          exclude_pull_requests: true,
          head_sha: pull_request.head.sha,
        })
      ).data.workflow_runs[0] ?? {}

    // Newer PRs might not have run Eval to completion, yet.
    // Older PRs might not have an eval.yml workflow, yet.
    // In either case we continue without fetching an artifact on a best-effort basis.
    log('Last eval run', run_id ?? '<n/a>')

    if (conclusion === 'success') {
      // Check for any human reviews other than GitHub actions and other GitHub apps.
      // Accounts could be deleted as well, so don't count them.
      const humanReviews = reviews.filter(
        (r) =>
          r.user && !r.user.login.endsWith('[bot]') && r.user.type !== 'Bot',
      )

      Object.assign(prLabels, {
        // We only set this label if the latest eval run was successful, because if it was not, it
        // *could* have requested reviewers. We will let the PR author fix CI first, before "escalating"
        // this PR to "needs: reviewer".
        // Since the first Eval run on a PR always sets rebuild labels, the same PR will be "recently
        // updated" for the next scheduled run. Thus, this label will still be set within a few minutes
        // after a PR is created, if required.
        // Note that a "requested reviewer" disappears once they have given a review, so we check
        // existing reviews, too.
        '9.needs: reviewer':
          !pull_request.draft &&
          pull_request.requested_reviewers.length === 0 &&
          humanReviews.length === 0,
      })
    }

    const artifact =
      run_id &&
      (
        await github.rest.actions.listWorkflowRunArtifacts({
          ...context.repo,
          run_id,
          name: 'comparison',
        })
      ).data.artifacts[0]

    // Instead of checking the boolean artifact.expired, we will give us a minute to
    // actually download the artifact in the next step and avoid that race condition.
    // Older PRs, where the workflow run was already eval.yml, but the artifact was not
    // called "comparison", yet, will skip the download.
    const expired =
      !artifact ||
      new Date(artifact?.expires_at ?? 0) < new Date(Date.now() + 60 * 1000)
    log('Artifact expires at', artifact?.expires_at ?? '<n/a>')
    if (!expired) {
      stats.artifacts++

      await artifactClient.downloadArtifact(artifact.id, {
        findBy: {
          repositoryName: context.repo.repo,
          repositoryOwner: context.repo.owner,
          token: core.getInput('github-token'),
        },
        path: path.resolve(pull_number.toString()),
        expectedHash: artifact.digest,
      })

      const maintainers = new Set(
        Object.keys(
          JSON.parse(
            await readFile(`${pull_number}/maintainers.json`, 'utf-8'),
          ),
        ).map((m) => Number.parseInt(m, 10)),
      )

      const evalLabels = JSON.parse(
        await readFile(`${pull_number}/changed-paths.json`, 'utf-8'),
      ).labels

      Object.assign(prLabels, evalLabels, {
        '12.approved-by: package-maintainer':
          maintainers.intersection(approvals).size > 0,
      })
    }

    return prLabels
  }

  // Returns true if the issue was closed. In this case, the labeling does not need to
  // continue for this issue. Returns false if no action was taken.
  async function handleAutoClose(item) {
    const issue_number = item.number

    if (item.labels.some(({ name }) => name === '0.kind: packaging request')) {
      const body = [
        'Thank you for your interest in packaging new software in Nixpkgs. Unfortunately, to mitigate the unsustainable growth of unmaintained packages, **Nixpkgs is no longer accepting package requests** via Issues.',
        '',
        'As a [volunteer community][community], we are always open to new contributors. If you wish to see this package in Nixpkgs, **we encourage you to [contribute] it yourself**, via a Pull Request. Anyone can [become a package maintainer][maintainers]! You can find language-specific packaging information in the [Nixpkgs Manual][nixpkgs]. Should you need any help, please reach out to the community on [Matrix] or [Discourse].',
        '',
        '[community]: https://nixos.org/community',
        '[contribute]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#quick-start-to-adding-a-package',
        '[maintainers]: https://github.com/NixOS/nixpkgs/blob/master/maintainers/README.md',
        '[nixpkgs]: https://nixos.org/manual/nixpkgs/unstable/',
        '[Matrix]: https://matrix.to/#/#dev:nixos.org',
        '[Discourse]: https://discourse.nixos.org/c/dev/14',
      ].join('\n')

      core.info(`Issue #${item.number}: auto-closed`)

      if (!dry) {
        await github.rest.issues.createComment({
          ...context.repo,
          issue_number,
          body,
        })

        await github.rest.issues.update({
          ...context.repo,
          issue_number,
          state: 'closed',
          state_reason: 'not_planned',
        })
      }

      return true
    }
    return false
  }

  async function handle({ item, stats }) {
    try {
      const log = (k, v, skip) => {
        core.info(`#${item.number} - ${k}: ${v}${skip ? ' (skipped)' : ''}`)
        return skip
      }

      log('Last updated at', item.updated_at)
      log('URL', item.html_url)

      const issue_number = item.number

      const itemLabels = {}

      if (item.pull_request || context.payload.pull_request) {
        stats.prs++
        Object.assign(itemLabels, await handlePullRequest({ item, stats }))
      } else {
        stats.issues++
        if (item.labels.some(({ name }) => name === '4.workflow: auto-close')) {
          // If this returns true, the issue was closed. In this case we return, to not
          // label the issue anymore. Most importantly this avoids unlabeling stale issues
          // which are closed via auto-close.
          if (await handleAutoClose(item)) return
        }
      }

      const latest_event_at = new Date(
        (
          await github.paginate(github.rest.issues.listEventsForTimeline, {
            ...context.repo,
            issue_number,
            per_page: 100,
          })
        )
          .filter(({ event }) =>
            [
              // These events are hand-picked from:
              //   https://docs.github.com/en/rest/using-the-rest-api/issue-event-types?apiVersion=2022-11-28
              // Each of those causes a PR/issue to *not* be considered as stale anymore.
              // Most of these use created_at.
              'assigned',
              'commented', // uses updated_at, because that could be > created_at
              'committed', // uses committer.date
              ...(item.labels.some(({ name }) => name === '5.scope: tracking')
                ? ['cross-referenced']
                : []),
              'head_ref_force_pushed',
              'milestoned',
              'pinned',
              'ready_for_review',
              'renamed',
              'reopened',
              'review_dismissed',
              'review_requested',
              'reviewed', // uses submitted_at
              'unlocked',
              'unmarked_as_duplicate',
            ].includes(event),
          )
          .map(
            ({ created_at, updated_at, committer, submitted_at }) =>
              new Date(
                updated_at ?? created_at ?? submitted_at ?? committer.date,
              ),
          )
          // Reverse sort by date value. The default sort() sorts by string representation, which is bad for dates.
          .sort((a, b) => b - a)
          .at(0) ?? item.created_at,
      )
      log('latest_event_at', latest_event_at.toISOString())

      const stale_at = new Date(new Date().setDate(new Date().getDate() - 180))

      // Create a map (Label -> Boolean) of all currently set labels.
      // Each label is set to True and can be disabled later.
      const before = Object.fromEntries(
        (
          await github.paginate(github.rest.issues.listLabelsOnIssue, {
            ...context.repo,
            issue_number,
          })
        ).map(({ name }) => [name, true]),
      )

      Object.assign(itemLabels, {
        '2.status: stale':
          !before['1.severity: security'] && latest_event_at < stale_at,
      })

      const after = Object.assign({}, before, itemLabels)

      // No need for an API request, if all labels are the same.
      const hasChanges = Object.keys(after).some(
        (name) => (before[name] ?? false) !== after[name],
      )
      if (log('Has changes', hasChanges, !hasChanges)) return

      // Skipping labeling on a pull_request event, because we have no privileges.
      const labels = Object.entries(after)
        .filter(([, value]) => value)
        .map(([name]) => name)
      if (log('Set labels', labels, dry)) return

      await github.rest.issues.setLabels({
        ...context.repo,
        issue_number,
        labels,
      })
    } catch (cause) {
      throw new Error(`Labeling #${item.number} failed.`, { cause })
    }
  }

  await withRateLimit({ github, core }, async (stats) => {
    if (context.payload.pull_request) {
      await handle({ item: context.payload.pull_request, stats })
    } else {
      const lastRun = (
        await github.rest.actions.listWorkflowRuns({
          ...context.repo,
          workflow_id: 'labels.yml',
          event: 'schedule',
          status: 'success',
          exclude_pull_requests: true,
          per_page: 1,
        })
      ).data.workflow_runs[0]

      const cutoff = new Date(
        Math.max(
          // Go back as far as the last successful run of this workflow to make sure
          // we are not leaving anyone behind on GHA failures.
          // Defaults to go back 1 hour on the first run.
          new Date(
            lastRun?.created_at ?? Date.now() - 1 * 60 * 60 * 1000,
          ).getTime(),
          // Go back max. 1 day to prevent hitting all API rate limits immediately,
          // when GH API returns a wrong workflow by accident.
          Date.now() - 24 * 60 * 60 * 1000,
        ),
      )
      core.info(`cutoff timestamp: ${cutoff.toISOString()}`)

      const updatedItems = await github.paginate(
        github.rest.search.issuesAndPullRequests,
        {
          q: [
            `repo:"${context.repo.owner}/${context.repo.repo}"`,
            'is:open',
            `updated:>=${cutoff.toISOString()}`,
          ].join(' AND '),
          per_page: 100,
          // TODO: Remove after 2025-11-04, when it becomes the default.
          advanced_search: true,
        },
      )

      let cursor

      // No workflow run available the first time.
      if (lastRun) {
        // The cursor to iterate through the full list of issues and pull requests
        // is passed between jobs as an artifact.
        const artifact = (
          await github.rest.actions.listWorkflowRunArtifacts({
            ...context.repo,
            run_id: lastRun.id,
            name: 'pagination-cursor',
          })
        ).data.artifacts[0]

        // If the artifact is not available, the next iteration starts at the beginning.
        if (artifact) {
          stats.artifacts++

          const { downloadPath } = await artifactClient.downloadArtifact(
            artifact.id,
            {
              findBy: {
                repositoryName: context.repo.repo,
                repositoryOwner: context.repo.owner,
                token: core.getInput('github-token'),
              },
              expectedHash: artifact.digest,
            },
          )

          cursor = await readFile(path.resolve(downloadPath, 'cursor'), 'utf-8')
        }
      }

      // From GitHub's API docs:
      //   GitHub's REST API considers every pull request an issue, but not every issue is a pull request.
      //   For this reason, "Issues" endpoints may return both issues and pull requests in the response.
      //   You can identify pull requests by the pull_request key.
      const allItems = await github.rest.issues.listForRepo({
        ...context.repo,
        state: 'open',
        sort: 'created',
        direction: 'asc',
        per_page: 100,
        after: cursor,
      })

      // Regex taken and comment adjusted from:
      // https://github.com/octokit/plugin-paginate-rest.js/blob/8e5da25f975d2f31dda6b8b588d71f2c768a8df2/src/iterator.ts#L36-L41
      // `allItems.headers.link` format:
      //   <https://api.github.com/repositories/4542716/issues?page=3&per_page=100&after=Y3Vyc29yOnYyOpLPAAABl8qNnYDOvnSJxA%3D%3D>; rel="next",
      //   <https://api.github.com/repositories/4542716/issues?page=1&per_page=100&before=Y3Vyc29yOnYyOpLPAAABl8xFV9DOvoouJg%3D%3D>; rel="prev"
      // Sets `next` to undefined if "next" URL is not present or `link` header is not set.
      const next = ((allItems.headers.link ?? '').match(
        /<([^<>]+)>;\s*rel="next"/,
      ) ?? [])[1]
      if (next) {
        cursor = new URL(next).searchParams.get('after')
        const uploadPath = path.resolve('cursor')
        await writeFile(uploadPath, cursor, 'utf-8')
        if (dry) {
          core.info(`pagination-cursor: ${cursor} (upload skipped)`)
        } else {
          // No stats.artifacts++, because this does not allow passing a custom token.
          // Thus, the upload will not happen with the app token, but the default github.token.
          await artifactClient.uploadArtifact(
            'pagination-cursor',
            [uploadPath],
            path.resolve('.'),
            {
              retentionDays: 1,
            },
          )
        }
      }

      // Some items might be in both search results, so filtering out duplicates as well.
      const items = []
        .concat(updatedItems, allItems.data)
        .filter(
          (thisItem, idx, arr) =>
            idx ===
            arr.findIndex((firstItem) => firstItem.number === thisItem.number),
        )

      ;(await Promise.allSettled(items.map((item) => handle({ item, stats }))))
        .filter(({ status }) => status === 'rejected')
        .map(({ reason }) =>
          core.setFailed(`${reason.message}\n${reason.cause.stack}`),
        )
    }
  })
}
