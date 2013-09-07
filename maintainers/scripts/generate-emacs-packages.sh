#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OUTPUT="../../pkgs/top-level/emacs-packages-generated.nix"

pushd $DIR
emacs --batch \
      --load "$DIR/generate-emacs-packages.el" \
      --eval "(nix-generate-emacs-packages \"${OUTPUT}\")"
popd
