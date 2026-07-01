#!/usr/bin/env node
'use strict'

const fs = require('fs')
const path = require('path')
const process = require('process')
const lockfile = require('./yarnpkg-lockfile.js')
const { urlToName } = require('./common.js')

const fixupYarnLock = async (lockContents, verbose) => {
  const lockData = lockfile.parse(lockContents)
  const urlRewrites = new Map()

  const fixedData = Object.fromEntries(
    Object.entries(lockData.object)
    .map(([dep, pkg]) => {
      if (pkg.resolved === undefined) {
        console.warn(`no resolved URL for package ${dep}`)
        var maybeFile = dep.split("@", 2)[1]
        if (maybeFile.startsWith("file:")) {
          console.log(`Rewriting URL for local file dependency ${dep}`)
          pkg.resolved = maybeFile
        }
        return [dep, pkg]
      }
      const [ url, hash ] = pkg.resolved.split("#", 2)

      if (hash || url.startsWith("https://codeload.github.com/")) {
        if (verbose) console.log(`Removing integrity for git dependency ${dep}`)
        delete pkg.integrity
      }

      if (verbose) console.log(`Rewriting URL ${url} for dependency ${dep}`)
      pkg.resolved = urlToName(url)
      if (hash)
        pkg.resolved += `#${hash}`

      // Yarn uses the lockfile entry key to decide which resolver to use.
      // Keys containing "git+" or ending in ".git" trigger the git resolver,
      // which tries to run the git binary. Strip these so yarn treats the
      // dependency as a regular tarball resolved from the offline cache.
      let fixedDep = dep.replace(/@git\+/, '@').replace(/\.git(#|$)/, '$1')
      if (fixedDep !== dep) {
        // Record the version URL rewrite so we can apply it to internal refs and package.json
        const oldVersion = dep.match(/^@?[^@]+@(.+)$/)[1]
        const newVersion = fixedDep.match(/^@?[^@]+@(.+)$/)[1]
        urlRewrites.set(oldVersion, newVersion)
        return [fixedDep, pkg]
      }
      return [dep, pkg]
    })
  )

  // Other lockfile entries may reference git dependencies in their
  // dependencies/optionalDependencies fields. These references must match the
  // rewritten keys above, otherwise yarn can't find the entry and falls back
  // to the git resolver.
  if (urlRewrites.size > 0) {
    for (const pkg of Object.values(fixedData)) {
      for (const depField of ['dependencies', 'optionalDependencies']) {
        if (!pkg[depField]) continue
        for (const [name, version] of Object.entries(pkg[depField])) {
          if (urlRewrites.has(version)) pkg[depField][name] = urlRewrites.get(version)
        }
      }
    }
  }

  if (verbose) console.log('Done')

  return { fixedData, urlRewrites }
}

// package.json may also reference git dependencies. Apply the same rewrites
// so that yarn's lookup keys match the rewritten lockfile entry keys.
const fixupPackageJson = async (pkgJsonPath, urlRewrites, verbose) => {
  if (urlRewrites.size === 0 || !fs.existsSync(pkgJsonPath)) return

  const pkgJson = JSON.parse(await fs.promises.readFile(pkgJsonPath, 'utf-8'))
  for (const field of ['dependencies', 'devDependencies', 'optionalDependencies']) {
    if (!pkgJson[field]) continue
    for (const [name, version] of Object.entries(pkgJson[field])) {
      if (urlRewrites.has(version)) {
        if (verbose) console.log(`Rewriting package.json ${field}.${name}: ${version} -> ${urlRewrites.get(version)}`)
        pkgJson[field][name] = urlRewrites.get(version)
      }
    }
  }
  await fs.promises.writeFile(pkgJsonPath, JSON.stringify(pkgJson, null, 2) + '\n')
}

const showUsage = async () => {
  process.stderr.write(`
syntax: fixup-yarn-lock [path to yarn.lock] [options]

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
    lockContents = await fs.promises.readFile(lockFile || 'yarn.lock', 'utf-8')
  } catch {
    showUsage()
  }

  const { fixedData, urlRewrites } = await fixupYarnLock(lockContents, verbose)
  await fs.promises.writeFile(lockFile || 'yarn.lock', lockfile.stringify(fixedData))

  const pkgJsonPath = path.join(path.dirname(lockFile || 'yarn.lock'), 'package.json')
  await fixupPackageJson(pkgJsonPath, urlRewrites, verbose)
}

main()
  .catch(e => {
    console.error(e)
    process.exit(1)
  })
