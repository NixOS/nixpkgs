#!/usr/bin/env bash

emacs --batch --load generate-emacs-packages.el --eval '(nix-generate-emacs-packages)'
