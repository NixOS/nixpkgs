import { createWriteStream } from 'node:fs'
import { mkdir } from 'node:fs/promises'
import { dirname, join } from 'node:path'
import { Readable } from 'node:stream'
import { finished } from 'node:stream/promises'
import { type ParseArgsOptionsConfig, parseArgs } from 'node:util'
import { configure, getConsoleSink, getLogger } from '@logtape/logtape'
import { type PackageSnapshot, readWantedLockfile } from '@pnpm/lockfile.fs'
import { registryUrlForPackage } from './registry.js'
import { urlToCachePath } from './util.js'
import { pMapIterable } from 'p-map'
import { removeSuffix } from '@pnpm/deps.path'

await configure({
	sinks: { console: getConsoleSink() },
	loggers: [
		{
			category: 'pnpm-fetch-cache',
			lowestLevel: process.env.NODE_ENV === 'development' ? 'debug' : 'info',
			sinks: ['console'],
		},
		{
			category: ['logtape', 'meta'],
			lowestLevel: 'warning',
		},
	],
})

const logger = getLogger(['pnpm-fetch-cache', 'index'])

const reqInit: RequestInit = {
	headers: {
		'User-Agent':
			'nixpkgs-fetch-pnpm-cache/1 (https://github.com/NixOS/nixpkgs)',
	},
}

const options: ParseArgsOptionsConfig = {
	path: {
		type: 'string',
		short: 'p',
	},
	outputPath: {
		type: 'string',
		short: 'o',
	},
} as const

const handleArgs = (args: string[]) => {
	const {
		values: { path, outputPath },
	} = parseArgs({ args, options })

	if (!path || typeof path !== 'string') {
		throw new Error('Argument --path is missing or invalid')
	}

	if (!outputPath || typeof outputPath !== 'string') {
		throw new Error('Argument --outputPath is missing or invalid')
	}

	return {
		path,
		outputPath,
	}
}

const downloadPackage = async (
	specifier: string,
	p: PackageSnapshot,
	outputPath: string,
) => {
	// TODO: add support for mirrors
	const url =
		'url' in p.resolution && typeof p.resolution.url === 'string'
			? p.resolution.url
			: registryUrlForPackage(specifier)

	const integrity = 'integrity' in p.resolution ? p.resolution.integrity : null

	logger.debug`Got URL ${url} and integrity ${integrity} for ${specifier}`

	if (!integrity) {
		logger.warn`Package ${specifier} does not have an integrity entry.`
	}

	const outputFile = join(outputPath, urlToCachePath(url))
	const outputDir = dirname(outputFile)

	await mkdir(outputDir, {
		recursive: true,
	})

	const handle = createWriteStream(outputFile)

	return await fetch(url, {
		...reqInit,
	}).then((r) => {
		if (!r.body) {
			throw new Error(`Empty response body for ${url}`)
		}

		return finished(Readable.fromWeb(r.body).pipe(handle))
	})
}

const main = async (args: string[]) => {
	const { path, outputPath } = handleArgs(args)

	const lockfile = await readWantedLockfile(path, { ignoreIncompatible: false })

	if (!lockfile?.packages) {
		throw new Error('Parsed lockfile is empty or missing')
	}

	logger.debug`Got lockfile ${lockfile}`

	const packages = Object.entries(lockfile.packages)

    for await (const { index } of pMapIterable(packages, async (pkg, index) => downloadPackage(pkg[0], pkg[1], outputPath).then(value => ({index, value})), {concurrency: 8})) {
        const [specifier] = packages[index];
        const packageId = removeSuffix(specifier);
        logger.info`Downloaded ${packageId}`
    };
}

main(process.argv.slice(2))
