# Auto rebase script

The [`./run.sh` script](./run.sh) in this directory rebases the current branch onto a target branch, while automatically resolving merge conflicts caused by marked commits in [`.git-blame-ignore-revs`](../../../.git-blame-ignore-revs).
See the header comment of that file to understand how to mark commits.

This is convenient for resolving merge conflicts for pull requests after e.g. treewide reformats.

## Testing

To run the tests in the [test directory](./test):
```
$ cd test
$ nix-shell
nix-shell> ./run.sh
```
