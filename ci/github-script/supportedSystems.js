module.exports = async ({ github, context, targetSha }) => {
  const { content, encoding } = (
    await github.rest.repos.getContent({
      ...context.repo,
      path: 'pkgs/top-level/release-supported-systems.json',
      ref: targetSha,
    })
  ).data
  return JSON.parse(Buffer.from(content, encoding).toString())
}
