#!/usr/bin/env nix-shell
#!nix-shell -i tclsh -p tcl common-updater-scripts curl

set changelog_url https://sourceforge.net/p/domination/code/HEAD/tree/Domination/ChangeLog.txt?format=raw

set changelog [exec -ignorestderr curl -Ls $changelog_url]
regexp {(\d+(\.\d+)*) \(\d+\.\d+\.\d+\) \(svn rev (\d+)\)} $changelog _ version _ rev
exec -ignorestderr update-source-version domination $version --rev=$rev
