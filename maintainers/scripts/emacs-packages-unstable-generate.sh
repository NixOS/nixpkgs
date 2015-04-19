#!/bin/sh

if ! git diff-files --quiet --ignore-submodules -- ; then
    echo "Please commit your changes first!"
    exit 1
fi

if ! git diff-index --cached --quiet HEAD --ignore-submodules -- ; then
    echo "Please commit your changes first!"
    exit 1
fi

time elpa2nix -o pkgs/top-level/emacs-packages-unstable.json \
     -i pkgs/top-level/emacs-packages.json \
     http://orgmode.org/elpa/ \
     http://melpa.org/packages/

git add pkgs/top-level/emacs-packages-unstable.json
git commit -m "update emacs-packages-unstable.json $(date --rfc-3339=seconds)"
