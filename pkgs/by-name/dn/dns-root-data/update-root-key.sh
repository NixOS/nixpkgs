#!/usr/bin/env nix-shell
#!nix-shell -i bash -p busybox unbound
# shellcheck shell=bash

TMP=`mktemp`
unbound-anchor -a "$TMP"
grep -Ev "^($$|;)" "$TMP" | sed -e 's/ ;;.*//' > root.key

unbound-anchor -F -a "$TMP"
sed '/^;/d' < "$TMP" > root.ds
rm $TMP
