#!/bin/sh

./maintainers/scripts/fetch-kde-qt.sh \
    http://download.kde.org/stable/frameworks/5.24/ -A '*.tar.xz' \
    >pkgs/desktops/kde-5/frameworks/srcs.nix
