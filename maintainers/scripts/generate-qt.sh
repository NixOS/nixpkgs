#!/bin/sh

./maintainers/scripts/fetch-kde-qt.sh \
    http://download.qt.io/official_releases/qt/5.7/5.7.0/submodules/ \
    -A '*.tar.xz' \
    >pkgs/development/libraries/qt-5/5.7/srcs.nix
