#!/bin/sh

buildcpath() {
  local path after
  while (( $# )); do
    case $1 in
        -isystem)
            shift
            path=$path${path:+':'}$1
            ;;
        -idirafter)
            shift
            after=$after${after:+':'}$1
            ;;
    esac
    shift
  done
  printf "%s" "$path${after:+':'}$after"
}

buildcpluspath() {
  local path after
  while (( $# )); do
    case $1 in
        -isystem|-cxx-isystem)
            shift
            path=$path${path:+':'}$1
            ;;
        -idirafter)
            shift
            after=$after${after:+':'}$1
            ;;
    esac
    shift
  done
  printf "%s" "$path${after:+':'}$after"
}

export C_INCLUDE_PATH=${CPATH}${CPATH:+':'}$(buildcpath ${NIX_CFLAGS_COMPILE} \
                                                        $(<@out@/nix-support/libc-cflags))

export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}${CPLUS_INCLUDE_PATH:+':'}$(buildcpluspath ${NIX_CFLAGS_COMPILE} \
                                                                                          $(<@out@/nix-support/libcxx-cxxflags) \
                                                                                          $(<@out@/nix-support/libc-cflags))

exec @prog@ "$@"
