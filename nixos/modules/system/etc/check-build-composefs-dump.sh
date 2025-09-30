#! /usr/bin/env nix-shell
#! nix-shell -i bash -p black ruff mypy

file=$1

black --check --diff $file
ruff --line-length 88 $file
mypy --strict $file
