#!/bin/sh

./maintainers/scripts/fetch-kde-qt.sh \
    http://download.kde.org/stable/applications/16.08.0/ -A '*.tar.xz' \
    >pkgs/desktops/kde-5/applications/srcs.nix
