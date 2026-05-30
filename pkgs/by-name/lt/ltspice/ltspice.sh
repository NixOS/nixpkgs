#!/usr/bin/env bash

# Original Authors: fenugrec <fenugrec users sourceforge net> and Max Stabel <max dot stabel03 at gmail dot com>

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ltspice"

if [[ ! -d $CONFIG_DIR ]]; then
   mkdir -p "$CONFIG_DIR"
fi
if [[ ! -f "$CONFIG_DIR/LTspice.ini" ]]; then
   # disable sending telemetry
   echo -e "[Options]\nCaptureAnalytics=false" > "$CONFIG_DIR/LTspice.ini"
fi

WINEPREFIX="${WINEPREFIX-"${XDG_DATA_HOME-"$HOME/.local/share"}"/ltspice}"
if [[ ! -d $WINEPREFIX ]]; then
   mkdir -p "$WINEPREFIX"
fi
WINEARCH=win64 WINEPREFIX=$WINEPREFIX WINEDLLOVERRIDES=winemenubuilder.exe=d wine start.exe /unix @outpath@/libexec/ltspice/LTspice.exe -ini $CONFIG_DIR/LTspice.ini "$@"
