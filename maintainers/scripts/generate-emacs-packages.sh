#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd $DIR
emacs --batch --load "$DIR/generate-emacs-packages.el" --eval '(nix-generate-emacs-packages)'
popd
