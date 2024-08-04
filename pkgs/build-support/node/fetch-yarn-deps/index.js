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
const url = require('url')
const { urlToName } = require('./common.js')

const execFile = promisify(child_process.execFile)

const exec = async (...args) => {
	const res = await execFile(...args)
	if (res.error) throw new Error(res.stderr)
	return res
}

const downloadFileHttps = (fileName, url, expectedHash, hashType = 'sha1') => {
	return new Promise((resolve, reject) => {
		const get = (url, redirects = 0) => https.get(url, (res) => {
			if(redirects > 10) {
				reject('Too many redirects!');
				return;
			}
			if(res.statusCode === 301 || res.statusCode === 302) {
				return get(res.headers.location, redirects + 1)
			}
			const file = fs.createWriteStream(fileName)
			const hash = crypto.createHash(hashType)
			res.pipe(file)
			res.pipe(hash).setEncoding('hex')
			res.on('end', () => {
				file.close()
				const h = hash.read()
				if (expectedHash === undefined){
					console.log(`Warning: lockfile url ${url} doesn't end in "#<hash>" to validate against. Downloaded file had hash ${h}.`);
				} else if (h != expectedHash) return reject(new Error(`hash mismatch, expected ${expectedHash}, got ${h} for ${url}`))
				resolve()
			})
                        res.on('error', e => reject(e))
		})
		get(url)
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

const isGitUrl = pattern => {
	// https://github.com/yarnpkg/yarn/blob/3119382885ea373d3c13d6a846de743eca8c914b/src/resolvers/exotics/git-resolver.js#L15-L47
	const GIT_HOSTS = ['github.com', 'gitlab.com', 'bitbucket.com', 'bitbucket.org']
	const GIT_PATTERN_MATCHERS = [/^git:/, /^git\+.+:/, /^ssh:/, /^https?:.+\.git$/, /^https?:.+\.git#.+/]

	for (const matcher of GIT_PATTERN_MATCHERS) if (matcher.test(pattern)) return true

	const {hostname, path} = url.parse(pattern)
	if (hostname && path && GIT_HOSTS.indexOf(hostname) >= 0
		// only if dependency is pointing to a git repo,
		// e.g. facebook/flow and not file in a git repo facebook/flow/archive/v1.0.0.tar.gz
		&& path.split('/').filter(p => !!p).length === 2
	) return true

	return false
}

const downloadPkg = (pkg, verbose) => {
	const fileMarker = '@file:'
	const split = pkg.key.split(fileMarker)
	if (split.length == 2) {
		console.info(`ignoring lockfile entry "${split[0]}" which points at path "${split[1]}"`)
		return
	} else if (split.length > 2) {
		throw new Error(`The lockfile entry key "${pkg.key}" contains "${fileMarker}" more than once. Processing is not implemented.`)
	}

	if (pkg.resolved === undefined) {
		throw new Error(`The lockfile entry with key "${pkg.key}" cannot be downloaded because it is missing the "resolved" attribute, which should contain the URL to download from. The lockfile might be invalid.`)
	}

	const [ url, hash ] = pkg.resolved.split('#')
	if (verbose) console.log('downloading ' + url)
	const fileName = urlToName(url)
	const s = url.split('/')
	if (url.startsWith('https://codeload.github.com/') && url.includes('/tar.gz/')) {
		return downloadGit(fileName, `https://github.com/${s[3]}/${s[4]}.git`, s[s.length-1])
	} else if (url.startsWith('https://github.com/') && url.endsWith('.tar.gz') &&
		(
			s.length <= 5 ||    // https://github.com/owner/repo.tgz#feedface...
			s[5] == "archive"   // https://github.com/owner/repo/archive/refs/tags/v0.220.1.tar.gz
		)) {
		return downloadGit(fileName, `https://github.com/${s[3]}/${s[4]}.git`, s[s.length-1].replace(/.tar.gz$/, ''))
	} else if (isGitUrl(url)) {
		return downloadGit(fileName, url.replace(/^git\+/, ''), hash)
	} else if (url.startsWith('https://')) {
		if (typeof pkg.integrity === 'string' || pkg.integrity instanceof String) {
			const [ type, checksum ] = pkg.integrity.split('-')
			return downloadFileHttps(fileName, url, Buffer.from(checksum, 'base64').toString('hex'), type)
		}
		return downloadFileHttps(fileName, url, hash)
	} else if (url.startsWith('file:')) {
		console.warn(`ignoring unsupported file:path url "${url}"`)
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
	await performParallel(
		Object.entries(lockData.object)
		.map(([key, value]) => () => downloadPkg({ key, ...value }, verbose))
	)
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
