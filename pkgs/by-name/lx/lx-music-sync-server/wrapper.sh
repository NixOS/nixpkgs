#! /usr/bin/env bash

if [[ -z "$LOG_PATH" ]]; then
    export LOG_PATH="/var/log/lx-music-sync-server"
fi

if [[ -z "$DATA_PATH" ]]; then
    export DATA_PATH="/var/lib/lx-music-sync-server"
fi

@@node@@ @@out@@/lib/node_modules/lx-music-sync-server/index.js
