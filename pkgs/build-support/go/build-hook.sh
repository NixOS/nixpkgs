
goBuildHook() {

  runHook preBuild

  export GOFLAGS

  # currently pie is only enabled by default in pkgsMusl
  # this will respect the `hardening{Disable,Enable}` flags if set
  if [[ $NIX_HARDENING_ENABLE =~ "pie" ]]; then
    prependToVar GOFLAGS "-buildmode=pie"
  fi

  if [ -z "${allowGoReference-}" ]; then
    appendToVar GOFLAGS "-trimpath"
  fi

  if [ -z "${proxyVendor-}" ]; then
    appendToVar GOFLAGS "-mod=vendor"
  fi

  # TODO: conditionalize
  appendToVar ldflags "-buildid="

  exclude='\(/_\|examples\|Godeps\|testdata'
  if [[ -n "$excludedPackages" ]]; then
    IFS=' ' read -r -a excludedArr <<<$excludedPackages
    printf -v excludedAlternates '%s\\|' "${excludedArr[@]}"
    excludedAlternates=${excludedAlternates%\\|} # drop final \| added by printf
    exclude+='\|'"$excludedAlternates"
  fi
  exclude+='\)'

  buildGoDir() {
    local cmd="$1" dir="$2"

    declare -ga buildFlagsArray
    declare -a flags
    flags+=($buildFlags "${buildFlagsArray[@]}")
    flags+=(${tags:+-tags=${tags// /,}})
    flags+=(${ldflags:+-ldflags="$ldflags"})
    flags+=("-p" "$NIX_BUILD_CORES")

    if [ "$cmd" = "test" ]; then
      flags+=(-vet=off)
      flags+=($checkFlags)
    fi

    local OUT
    if ! OUT="$(go $cmd "${flags[@]}" $dir 2>&1)"; then
      if ! echo "$OUT" | grep -qE '(no( buildable| non-test)?|build constraints exclude all) Go (source )?files'; then
        echo "$OUT" >&2
        return 1
      fi
    fi
    if [ -n "$OUT" ]; then
      echo "$OUT" >&2
    fi
    return 0
  }

  getGoDirs() {
    local type;
    type="$1"
    if [ -n "$subPackages" ]; then
      echo "$subPackages" | sed "s,\(^\| \),\1./,g"
    else
      find . -type f -name \*$type.go -exec dirname {} \; | grep -v "/vendor/" | sort --unique | grep -v "$exclude"
    fi
  }

  if (( "${NIX_DEBUG:-0}" >= 1 )); then
    buildFlagsArray+=(-x)
  fi

  if [ -z "$enableParallelBuilding" ]; then
      export NIX_BUILD_CORES=1
  fi

  if [ -n "${modRoot}" ]; then
    pushd "$modRoot"
  fi

  for pkg in $(getGoDirs ""); do
    echo "Building subPackage $pkg"
    buildGoDir install "$pkg"
  done

  if [ -n "${modRoot}" ]; then
    popd
  fi

  # TODO: maybe conditionalize: only run if actually cross

  # normalize cross-compiled builds w.r.t. native builds
  (
    dir="$GOPATH"/bin/"$GOOS"_"$GOARCH"
    if [[ -n "$(shopt -s nullglob; echo "$dir"/*)" ]]; then
      mv "$dir"/* "$dir"/..
    fi
    if [[ -d "$dir" ]]; then
      rmdir "$dir"
    fi
  )

  runHook postBuild
}

goCheckHook() {
  runHook preCheck

  # We do not set trimpath for tests, in case they reference test assets
  export GOFLAGS="${GOFLAGS//-trimpath/}"

  if [ -n "${modRoot}" ]; then
    pushd "$modRoot"
  fi

  for pkg in $(getGoDirs test); do
    buildGoDir test "$pkg"
  done

  if [ -n "${modRoot}" ]; then
    popd
  fi

  runHook postCheck
}


if [ -z "${dontGoBuild-}" ] && [ -z "${buildPhase-}" ]; then
  buildPhase=goBuildHook
fi


if [ -z "${dontGoCheck-}" ] && [ -z "${checkPhase-}" ]; then
  checkPhase=goCheckHook
fi


