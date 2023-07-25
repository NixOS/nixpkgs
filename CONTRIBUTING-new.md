# Contributing to Nixpkgs

## (Proposing a change)

When pull requests are made, our tooling automation bot,
[OfBorg](https://github.com/NixOS/ofborg) will perform various checks
to help ensure expression quality.

## (Merging a pull request)

The *Nixpkgs committers* are people who have been given
permission to merge.

## (Flow of changes)

Most contributions are based on and merged into these branches:

* `master` is the main branch where all small contributions go
* `staging` is branched from master, changes that have a big impact on
  Hydra builds go to this branch
* `staging-next` is branched from staging and only fixes to stabilize
  and security fixes with a big impact on Hydra builds should be
  contributed to this branch. This branch is merged into master when
  deemed of sufficiently high quality
