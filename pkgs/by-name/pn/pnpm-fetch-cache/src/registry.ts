import { getLogger } from '@logtape/logtape'
import { removeSuffix } from '@pnpm/deps.path'

const logger = getLogger(['pnpm-fetch-cache', 'index'])

export const defaultRegistry = 'https://registry.npmjs.org' as const

const namePattern = /^(@?[^@/]+(?:\/([^@/]+))?)@(.+)$/

export const registryUrlForPackage = (
	specifier: string,
	registry: string = defaultRegistry,
) => {
	const packageId = removeSuffix(specifier)

	const matches = packageId.match(namePattern)
	if (!matches || matches.length < 4) {
		throw new Error(`Package ${packageId} did not match pattern`)
	}

	logger.debug`Package ${packageId} matched ${matches}`

	const fullName = matches[1]
	// Scoped packages (e.g. @scope/name) need special treatment
	const packageName = matches[2] ?? fullName
	const version = matches[3]

	// Crude way to check if dependency is pinned to a URL
	// TODO: parse URL instead!
	if (version.startsWith('http')) {
		logger.info`Using pinned URL ${version} for ${packageId}`
		return version
	}

	const url = new URL(`${fullName}/-/${packageName}-${version}.tgz`, registry)
	logger.debug`Resolved URL ${url} for ${packageId}`
	return url
}
