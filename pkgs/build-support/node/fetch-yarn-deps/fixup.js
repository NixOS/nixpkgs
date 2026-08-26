#!/usr/bin/env node
'use strict'

const fs = require('fs')
const process = require('process')
const lockfile = require('./yarnpkg-lockfile.js')
const { urlToName } = require('./common.js')

const fixupYarnLock = async (lockContents, verbose) => {
  const lockData = lockfile.parse(lockContents)

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

      return [dep, pkg]
    })
  )

  if (verbose) console.log('Done')

  return fixedData
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

  const fixedData = await fixupYarnLock(lockContents, verbose)
  await fs.promises.writeFile(lockFile || 'yarn.lock', lockfile.stringify(fixedData))
}

main()
  .catch(e => {
    console.error(e)
    process.exit(1)
  })
