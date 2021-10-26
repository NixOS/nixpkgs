#!/usr/bin/env node
'use strict'

const fs = require('fs')
const crypto = require('crypto')
const process = require('process')
const https = require('https')
const child_process = require('child_process')
const path = require('path')
const lockfile = require('./yarnpkg-lockfile.js')
const { promisify } = require('util')

const execFile = promisify(child_process.execFile)

const exec = async (...args) => {
	const res = await execFile(...args)
	if (res.error) throw new Error(res.stderr)
	return res
}

const downloadFileHttps = (fileName, url, expectedHash) => {
	return new Promise((resolve, reject) => {
		https.get(url, (res) => {
			const file = fs.createWriteStream(fileName)
			const hash = crypto.createHash('sha1')
			res.pipe(file)
			res.pipe(hash).setEncoding('hex')
			res.on('end', () => {
				file.close()
				const h = hash.read()
				if (h != expectedHash) return reject(new Error(`hash mismatch, expected ${expectedHash}, got ${h}`))
				resolve()
			})
                        res.on('error', e => reject(e))
		})
	})
}

const downloadGit = async (fileName, url, rev) => {
	await exec('nix-prefetch-git', [
		'--out', fileName + '.tmp',
		'--url', url,
		'--rev', rev,
		'--builder'
	])

	await exec('tar', [
		// hopefully make it reproducible across runs and systems
		'--owner=0', '--group=0', '--numeric-owner', '--format=gnu', '--sort=name', '--mtime=@1',

		// Set u+w because tar-fs can't unpack archives with read-only dirs: https://github.com/mafintosh/tar-fs/issues/79
		'--mode', 'u+w',

		'-C', fileName + '.tmp',
		'-cf', fileName, '.'
	])

	await exec('rm', [ '-rf', fileName + '.tmp', ])
}

const downloadPkg = (pkg, verbose) => {
	const [ url, hash ] = pkg.resolved.split('#')
	if (verbose) console.log('downloading ' + url)
	if (url.startsWith('https://codeload.github.com/') && url.includes('/tar.gz/')) {
		const fileName = path.basename(url)
		const s = url.split('/')
		downloadGit(fileName, `https://github.com/${s[3]}/${s[4]}.git`, s[6])
	} else if (url.startsWith('https://')) {
		const fileName = url
			.replace(/https:\/\/(.)*(.com)\//g, '') // prevents having long directory names
			.replace(/[@/%:-]/g, '_') // replace @ and : and - and % characters with underscore

		return downloadFileHttps(fileName, url, hash)
	} else if (url.startsWith('git+')) {
		const fileName = path.basename(url)
		return downloadGit(fileName, url.replace(/^git\+/, ''), hash)
	} else {
		throw new Error('don\'t know how to download "' + url + '"')
	}
}

const performParallel = tasks => {
	const worker = async () => {
		while (tasks.length > 0) await tasks.shift()()
	}

	const workers = []
	for (let i = 0; i < 4; i++) {
		workers.push(worker())
	}

	return Promise.all(workers)
}

const prefetchYarnDeps = async (lockContents, verbose) => {
	const lockData = lockfile.parse(lockContents)
	const tasks = Object.values(
		Object.entries(lockData.object)
		.map(([key, value]) => {
			return { key, ...value }
		})
		.reduce((out, pkg) => {
			out[pkg.resolved] = pkg
			return out
		}, {})
	)
		.map(pkg => () => downloadPkg(pkg, verbose))

	await performParallel(tasks)
	await fs.promises.writeFile('yarn.lock', lockContents)
	if (verbose) console.log('Done')
}

const showUsage = async () => {
	process.stderr.write(`
syntax: prefetch-yarn-deps [path to yarn.lock] [options]

Options:
  -h --help         Show this help
  -v --verbose      Verbose output
  --builder         Only perform the download to current directory, then exit
`)
	process.exit(1)
}

const main = async () => {
	const args = process.argv.slice(2)
	let next, lockFile, verbose, isBuilder
	while (next = args.shift()) {
		if (next == '--builder') {
			isBuilder = true
		} else if (next == '--verbose' || next == '-v') {
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
		lockContents = await fs.promises.readFile(lockFile || 'yarn.lock', 'utf-8')
	} catch {
		showUsage()
	}

	if (isBuilder) {
		await prefetchYarnDeps(lockContents, verbose)
	} else {
		const { stdout: tmpDir } = await exec('mktemp', [ '-d' ])

		try {
			process.chdir(tmpDir.trim())
			await prefetchYarnDeps(lockContents, verbose)
			const { stdout: hash } = await exec('nix-hash', [ '--type', 'sha256', '--base32', tmpDir.trim() ])
			console.log(hash)
		} finally {
			await exec('rm', [ '-rf', tmpDir.trim() ])
		}
	}
}

main()
	.catch(e => {
		console.error(e)
		process.exit(1)
	})
