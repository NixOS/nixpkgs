#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OUTPUT="../../pkgs/top-level/emacs-packages-generated.nix"

if [ -z "$NIX_EMACS_PACKAGE_CACHE_DIR" ]
then
  export NIX_EMACS_PACKAGE_CACHE_DIR="/tmp/nix-emacs-packages/"
fi

pushd $DIR
emacs --batch \
      --load "$DIR/generate-emacs-packages.el" \
      --eval "(nix-generate-emacs-packages \"${OUTPUT}\")"
popd
