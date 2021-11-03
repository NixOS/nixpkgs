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

// This has to match the logic in pkgs/development/tools/yarn2nix-moretea/yarn2nix/lib/urlToName.js
// so that fixup_yarn_lock produces the same paths
const urlToName = url => {
  const isCodeloadGitTarballUrl = url.startsWith('https://codeload.github.com/') && url.includes('/tar.gz/')

  if (url.startsWith('git+') /*|| yarnExotics[new URL(url).pathname]*/ || isCodeloadGitTarballUrl) {
    return path.basename(url)
  } else {
    return url
      .replace(/https:\/\/(.)*(.com)\//g, '') // prevents having long directory names
      .replace(/[@/%:-]/g, '_') // replace @ and : and - and % characters with underscore
  }
}

const downloadFileHttps = (fileName, url, expectedHash) => {
	return new Promise((resolve, reject) => {
		https.get(url, (res) => {
			const file = fs.createWriteStream(fileName)
			const hash = crypto.createHash(expectedHash.type)
			res.pipe(file)
			res.pipe(hash).setEncoding('hex')
			res.on('end', () => {
				file.close()
				const h = hash.read()
				if (h != expectedHash.string) return reject(new Error(`[${url}]: hash mismatch, expected ${expectedHash.string}, got ${h}`))
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


// yarn automatically detects https urls pointing to git repos and converts them into their respective git url
// this reproduces this behaviour
// yarn's code: https://github.com/yarnpkg/yarn/tree/master/src/resolvers/exotics
const genericGit = ({ url, fileName, rev }) => {
	return downloadGit(fileName, url, rev)		
}

// TODO: maybe turn this into an impl that can be reused by both fixup_yarn_lock and fetch-yarn-deps by adding a .getFilename() method and making it importable from both
const yarnExotics = {
	'codeload.github.com': ({ url, fileName, hash }) => {
		// https://codeload.github.com/hirak/prestissimo/zip/refs/heads/master
		const [user, repo, type, , , rev] = exploded.pathExploded
		return downloadGit(fileName, `https://github.com/${user}/${repo}.git`, rev)
	},
	'github.com': genericGit,
	'bitbucket.org': genericGit,
	'gist.github.com': (args) => {
		return genericGit({ ...args, url: `https://gist.github.com/${args.exploded.pathExploded[0]}` })
	},
	'gitlab.com': genericGit,
}

const downloadPkg = (pkg, verbose) => {
	const [ url, rev ] = pkg.resolved.split('#') // rev might be null
	const integrity = pkg.integrity

	let hash
	if (integrity) { // this is the stronger hash so we should use that, rev is just sha1
	  let [ type, hash64 ] = integrity.split('-')
	  hash = { type, string: Buffer.from(hash64, 'base64').toString('hex') }
	} else {
	  hash = { type: 'sha1', string: rev }
	}

	const exploded = new URL(url)
	exploded.pathExploded = exploded.pathname.split('/').slice(1)

	if (verbose) console.log('downloading ' + url)

	const fileName = urlToName(url)

	/*if (yarnExotics[exploded.hostname]) {
		return yarnExotics[exploded.hostname]({ url, fileName, hash, exploded, rev })
	} else*/ if (url.startsWith('https://')) {
		return downloadFileHttps(fileName, url, hash)
	} else if (exploded.protocol === 'git:') {
		return downloadGit(fileName, url.replace(/^git\+/, ''), rev)
	} else if (exploded.protocol.startsWith('git+')) {
		return downloadGit(fileName, url.replace(/^git\+/, ''), rev)
	} else if (exploded.protocol === 'file:') {
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
