#!/usr/bin/env node
'use strict'

const fs = require('fs')
const process = require('process')
const { urlToName, stripJsonComments } = require('./common.js')
const { parseBunLock } = require('./parser.js')

const inferNpmUrl = (nameVersion) => {
	const parts = nameVersion.split('@').filter(Boolean)
	const version = parts.pop()
	const name = parts.join('@')
	const filename = name.startsWith('@') ? name.replace('/', '%2f') : name
	return `https://registry.npmjs.org/${name}/-/${filename}-${version}.tgz`
}

const fixupBunLock = async (lockContents, verbose) => {
	const lockData = parseBunLock(lockContents, stripJsonComments)

	if (!lockData.packages) {
		throw new Error('Invalid bun.lock format: missing "packages" property')
	}

	const fixedPackages = {}

	for (const [name, details] of Object.entries(lockData.packages)) {
		if (!Array.isArray(details)) {
			if (verbose) console.warn(`Skipping non-array format for ${name}: ${JSON.stringify(details)}`)
			fixedPackages[name] = details
			continue
		}

		let [nameVersion, url, metadata, integrity] = details
		const newDetails = [...details]

		// workspace:
		if (url?.startsWith('workspace:')) {
			if (verbose) console.log(`Preserving workspace package: ${name} (${url})`)
			fixedPackages[name] = details
			continue
		}

		// file:
		if (url?.startsWith('file:')) {
			if (verbose) console.log(`Preserving file dependency for ${name}`)
			fixedPackages[name] = details
			continue
		}

		// ❗️Empty or missing URL — infer and replace it
		if (!url || url === '') {
			const inferredUrl = inferNpmUrl(nameVersion)
			if (verbose) console.log(`Inferred URL for ${name}: ${inferredUrl}`)
			newDetails[1] = urlToName(inferredUrl)
		} else {
			if (verbose) console.log(`Rewriting URL ${url} for dependency ${name}`)
			newDetails[1] = urlToName(url)

			if (url.startsWith('git+') || url.startsWith('https://codeload.github.com/')) {
				if (verbose) console.log(`Removing integrity for git dependency ${name}`)
				if (newDetails.length >= 4) {
					newDetails[3] = undefined
				}
			}
		}

		fixedPackages[name] = newDetails
	}

	const fixedLockData = {
		...lockData,
		packages: fixedPackages
	}

	if (verbose) console.log('Lockfile fixup complete')

	return fixedLockData
}

const showUsage = () => {
	process.stderr.write(`
syntax: fixup-bun-lock [path to bun.lock] [options]

Options:
  -h --help         Show this help
  -v --verbose      Verbose output
`)
	process.exit(1)
}

const main = async () => {
	const args = process.argv.slice(2)
	let next, lockFile, verbose
	while ((next = args.shift())) {
		if (next === '--verbose' || next === '-v') {
			verbose = true
		} else if (next === '--help' || next === '-h') {
			showUsage()
		} else if (!lockFile) {
			lockFile = next
		} else {
			showUsage()
		}
	}
	let lockContents
	try {
		lockContents = await fs.promises.readFile(lockFile || 'bun.lock', 'utf-8')
	} catch {
		showUsage()
	}

	const fixedData = await fixupBunLock(lockContents, verbose)
	const jsonOutput = JSON.stringify(fixedData, null, 2)
	await fs.promises.writeFile(lockFile || 'bun.lock', jsonOutput)
}

main().catch((e) => {
	console.error(e)
	process.exit(1)
})
