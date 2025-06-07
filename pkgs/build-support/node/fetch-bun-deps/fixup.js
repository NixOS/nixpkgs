#!/usr/bin/env node
'use strict'

const fs = require('fs')
const process = require('process')
const { urlToName, stripJsonComments } = require('./common.js')
const { parseBunLock } = require('./parser.js')

const fixupBunLock = async (lockContents, verbose) => {
	const lockData = parseBunLock(lockContents, stripJsonComments)

	if (!lockData.packages) {
		throw new Error('Invalid bun.lock format: missing "packages" property')
	}

	// Modify the packages section to use local paths
	const fixedPackages = {}

	for (const [name, details] of Object.entries(lockData.packages)) {
		// Handle non-array entries (typically workspace references)
		if (!Array.isArray(details)) {
			if (verbose) console.warn(`Skipping non-array format for ${name}: ${JSON.stringify(details)}`)
			fixedPackages[name] = details
			continue
		}

		const [nameVersion, url, metadata, integrity] = details

		// Skip workspace packages
		if (url && typeof url === 'string' && url.startsWith('workspace:')) {
			if (verbose) console.log(`Preserving workspace package: ${name} (${url})`)
			fixedPackages[name] = details
			continue
		}

		// Handle file dependencies
		if (url && typeof url === 'string' && url.startsWith('file:')) {
			if (verbose) console.log(`Preserving file dependency for ${name}`)
			fixedPackages[name] = details
			continue
		}

		if (!url || typeof url !== 'string') {
			if (verbose) console.warn(`No valid URL for package ${name}, keeping as is`)
			fixedPackages[name] = details
			continue
		}

		if (verbose) console.log(`Rewriting URL ${url} for dependency ${name}`)

		// Create a new array with the URL rewritten
		const newDetails = [...details]

		// For git dependencies, remove integrity
		if (url.startsWith('git+') || url.startsWith('https://codeload.github.com/')) {
			if (verbose) console.log(`Removing integrity for git dependency ${name}`)
			if (newDetails.length >= 4) {
				newDetails[3] = undefined // Remove integrity
			}
		}

		// Rewrite the URL to the local path
		newDetails[1] = urlToName(url)

		fixedPackages[name] = newDetails
	}

	// Create a new lockfile with the fixed packages
	const fixedLockData = {
		...lockData,
		packages: fixedPackages
	}

	if (verbose) console.log('Done')

	return fixedLockData
}

const showUsage = async () => {
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
	while (next = args.shift()) {
		if (next == '--verbose' || next == '-v') {
			verbose = true
		} else if (next == '--help' || next == '-h') {
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

	// Format the JSON in the same style as the original bun.lock file
	// This preserves formatting that Bun expects
	const jsonOutput = JSON.stringify(fixedData, null, 2)

	await fs.promises.writeFile(lockFile || 'bun.lock', jsonOutput)
}

main()
	.catch(e => {
		console.error(e)
		process.exit(1)
	})
