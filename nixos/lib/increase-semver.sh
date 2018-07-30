#!/usr/bin/env sh

# https://github.com/fmahnke/shell-semver/blob/ba65f371f61b651ed95d6ebff42708f747e811b8/increment_version.sh

# Increment a version string using Semantic Versioning (SemVer) terminology.
# Parse command line options.

function increaseSemver() {
  v=$1

  case $2 in
    M ) major=true;;
    m ) minor=true;;
    p ) patch=true;;
  esac

  # Build array from version string.

  a=( ${v//./ } )

  # Increment version numbers as requested.

  if [ ! -z $major ]
  then
    ((a[0]++))
    a[1]=0
    a[2]=0
  fi

  if [ ! -z $minor ]
  then
    ((a[1]++))
    a[2]=0
  fi

  if [ ! -z $patch ]
  then
    ((a[2]++))
  fi

  echo "${a[0]}.${a[1]}.${a[2]}"
}

