#!/usr/bin/env bash

echo Placating Nuget in nuget.targets
find -iname nuget.targets -print -exec sed --in-place=bak -e 's,mono --runtime[^<]*,true NUGET PLACATED BY buildDotnetPackage,g' {} \;

echo Just to be sure, replacing Nuget executables by empty files.
find . -iname nuget.exe \! -size 0 -exec mv -v {} {}.bak \; -exec touch {} \;
