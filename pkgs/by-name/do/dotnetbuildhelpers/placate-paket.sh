#!/usr/bin/env bash

echo Placating Paket in paket.targets
find -iname paket.targets -print -exec sed --in-place=bak -e 's,mono --runtime[^<]*,true PAKET PLACATED BY buildDotnetPackage,g' {} \;

echo Just to be sure, replacing Paket executables by empty files.
find . -iname paket\*.exe \! -size 0 -exec mv -v {} {}.bak \; -exec touch {} \;
