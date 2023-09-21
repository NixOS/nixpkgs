#!/usr/bin/env nix-shell
#! nix-shell -p coreutils -i bash

scriptDir=$(cd "`dirname "$0"`"; pwd)
echo "scriptDir='$scriptDir'"

function get_pkg_out() {
  local pkg="$1"
  local suffix="${2:-}"
  local nixExp="with (import <nixpkgs> {}); ${pkg}"
  echo "$(nix-build -E "$nixExp" --no-out-link)${suffix}"
}

interpreter="$(get_pkg_out "stdenv.cc.libc" "/lib/ld-linux-x86-64.so.2")"
echo "interpreter='$interpreter'"

# For clangformat dep on 'libtinfo.so.5'.
ncursesLibDir="$(get_pkg_out "ncurses5.out" "/lib")"
echo "ncursesLibDir='$ncursesLibDir'"

# For clanformat dep on 'libstdc++.so.6'.
stdcppLibDir="$(get_pkg_out "stdenv.cc.cc.lib" "/lib")"
echo "stdcppLibDir='$stdcppLibDir'"

# For clangformat dep on 'libz.so.1'.
zlibLibDir="$(get_pkg_out "zlib.out" "/lib")"
echo "zlibLibDir='$zlibLibDir'"

function patchelf_mono() {
  local exe="$1"
  patchelf --set-interpreter "$interpreter" "$exe"
}

function patchelf_clangformat() {
  local exe="$1"
  patchelf --set-interpreter "$interpreter" "$exe"
  local rpath="$ncursesLibDir:$stdcppLibDir:$zlibLibDir"
  patchelf --set-rpath "$rpath" "$exe"
}

function print_nix_version_clangtools() {
  nixClangToolsBin="$(get_pkg_out "clang-tools" "/bin")"
  echo "nixClangToolsBin='$nixClangToolsBin'"
  $nixClangToolsBin/clang-format --version
}

function print_nix_version_mono() {
  nixMonoBin="$(get_pkg_out "mono" "/bin")"
  echo "nixMonoBin='$nixMonoBin'"
  $nixMonoBin/mono --version
}
