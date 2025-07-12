#!/usr/bin/env node
import { execSync } from 'node:child_process'
import { mkdtempSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { getOctokit } from '@actions/github'
import labels from './labels.cjs'

if (process.argv.length !== 4)
  throw new Error('Call this with exactly three arguments: ./run OWNER REPO')
const [, , owner, repo] = process.argv

const token = execSync('gh auth token', { encoding: 'utf-8' }).trim()

const tmp = mkdtempSync(join(tmpdir(), 'labels-'))
try {
  process.env.GITHUB_WORKSPACE = tmp
  process.chdir(tmp)

  await labels({
    github: getOctokit(token),
    context: {
      payload: {},
      repo: {
        owner,
        repo,
      },
    },
    core: {
      getInput() {
        return token
      },
      error: console.error,
      info: console.log,
      notice: console.log,
      setFailed(msg) {
        console.error(msg)
        process.exitCode = 1
      },
    },
    dry: true,
  })
} finally {
  rmSync(tmp, { recursive: true })
}
