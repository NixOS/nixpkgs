#!/bin/sh

./maintainers/scripts/fetch-kde-qt.sh \
    http://download.kde.org/stable/plasma/5.7.2/ -A '*.tar.xz' \
    >pkgs/desktops/kde-5/plasma/srcs.nix
