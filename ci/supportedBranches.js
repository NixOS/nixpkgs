#!/usr/bin/env nix-shell
/*
#!nix-shell -i node -p nodejs
*/

const typeConfig = {
  master: ['development', 'primary'],
  release: ['development', 'primary'],
  staging: ['development', 'secondary'],
  'staging-next': ['development', 'secondary'],
  'haskell-updates': ['development', 'secondary'],
  'python-updates': ['development', 'secondary'],
  nixos: ['channel'],
  nixpkgs: ['channel'],
}

function split(branch) {
  return { ...branch.match(/(?<prefix>.+?)(-(?<version>\d{2}\.\d{2}|unstable)(?:-(?<suffix>.*))?)?$/).groups }
}

function classify(branch) {
  const { prefix, version } = split(branch)
  return {
    stable: (version ?? 'unstable') !== 'unstable',
    type: typeConfig[prefix] ?? [ 'wip' ]
  }
}

module.exports = { classify }

// If called directly via CLI, runs the following tests:
if (!module.parent) {
  console.log('split(branch)')
  function testSplit(branch) {
    console.log(branch, split(branch))
  }
  testSplit('master')
  testSplit('release-25.05')
  testSplit('staging-next')
  testSplit('staging-25.05')
  testSplit('staging-next-25.05')
  testSplit('nixpkgs-25.05-darwin')
  testSplit('nixpkgs-unstable')
  testSplit('haskell-updates')
  testSplit('backport-123-to-release-25.05')

  console.log('')

  console.log('classify(branch)')
  function testClassify(branch) {
    console.log(branch, classify(branch))
  }
  testClassify('master')
  testClassify('release-25.05')
  testClassify('staging-next')
  testClassify('staging-25.05')
  testClassify('staging-next-25.05')
  testClassify('nixpkgs-25.05-darwin')
  testClassify('nixpkgs-unstable')
  testClassify('haskell-updates')
  testClassify('backport-123-to-release-25.05')
}
