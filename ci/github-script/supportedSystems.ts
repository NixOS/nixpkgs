interface SupportedSystemsProps {
  github: InstanceType<typeof import('@actions/github/lib/utils').GitHub>
  context: typeof import('@actions/github').context
  targetSha: string
}

export default async ({
  github,
  context,
  targetSha,
}: SupportedSystemsProps) => {
  const contentObject = (
    await github.rest.repos.getContent({
      ...context.repo,
      path: 'pkgs/top-level/release-supported-systems.json',
      ref: targetSha,
    })
  ).data

  if ('type' in contentObject && contentObject.type === 'file') {
    const { content, encoding } = contentObject
    return JSON.parse(
      Buffer.from(content, encoding as BufferEncoding).toString(),
    )
  } else {
    throw new Error(
      'Fetched pkgs/top-level/release-supported-systems.json is not a file',
    )
  }
}
