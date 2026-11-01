#!@shell@
# shellcheck shell=bash

if [ -e ~/.config/freeorion/config.xml ]; then
  @libxsltBin@/bin/xsltproc -o ~/.config/freeorion/config.xml @out@/share/freeorion/fix-paths.xslt ~/.config/freeorion/config.xml
fi
exit 0
