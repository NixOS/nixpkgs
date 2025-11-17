module.exports = async ({ github, core, maxConcurrent = 1 }, callback) => {
  const Bottleneck = require('bottleneck')

  const stats = {
    issues: 0,
    prs: 0,
    requests: 0,
    artifacts: 0,
  }

  // Rate-Limiting and Throttling, see for details:
  //   https://github.com/octokit/octokit.js/issues/1069#throttling
  //   https://docs.github.com/en/rest/using-the-rest-api/best-practices-for-using-the-rest-api
  const allLimits = new Bottleneck({
    // Avoid concurrent requests
    maxConcurrent,
    // Will be updated with first `updateReservoir()` call below.
    reservoir: 0,
  })
  // Pause between mutative requests
  const writeLimits = new Bottleneck({ minTime: 1000 }).chain(allLimits)
  github.hook.wrap('request', async (request, options) => {
    // Requests to a different host do not count against the rate limit.
    if (options.url.startsWith('https://github.com')) return request(options)
    // Requests to the /rate_limit endpoint do not count against the rate limit.
    if (options.url === '/rate_limit') return request(options)
    // Search requests are in a different resource group, which allows 30 requests / minute.
    // We do less than a handful each run, so not implementing throttling for now.
    if (options.url.startsWith('/search/')) return request(options)
    stats.requests++
    if (['POST', 'PUT', 'PATCH', 'DELETE'].includes(options.method))
      return writeLimits.schedule(request.bind(null, options))
    else return allLimits.schedule(request.bind(null, options))
  })

  async function updateReservoir() {
    let response
    try {
      response = await github.rest.rateLimit.get()
    } catch (err) {
      core.error(`Failed updating reservoir:\n${err}`)
      // Keep retrying on failed rate limit requests instead of exiting the script early.
      return
    }
    // Always keep 1000 spare requests for other jobs to do their regular duty.
    // They normally use below 100, so 1000 is *plenty* of room to work with.
    const reservoir = Math.max(0, response.data.resources.core.remaining - 1000)
    core.info(`Updating reservoir to: ${reservoir}`)
    allLimits.updateSettings({ reservoir })
  }
  await updateReservoir()
  // Update remaining requests every minute to account for other jobs running in parallel.
  const reservoirUpdater = setInterval(updateReservoir, 60 * 1000)

  try {
    await callback(stats)
  } finally {
    clearInterval(reservoirUpdater)
    core.notice(
      `Processed ${stats.prs} PRs, ${stats.issues} Issues, made ${stats.requests + stats.artifacts} API requests and downloaded ${stats.artifacts} artifacts.`,
    )
  }
}
