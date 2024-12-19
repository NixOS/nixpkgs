goConfigHook() {
  export GOCACHE=$TMPDIR/go-cache
  export GOPATH="$TMPDIR/go"
  export GOPROXY=off
  export GOSUMDB=off

  if [ -d "${goModules-}" ]; then
    if [ -n "${proxyVendor-}" ]; then
      export GOPROXY="file://$goModules"
    else

      if [ -n "${modRoot}" ]; then
        pushd "$modRoot"
      fi

      rm -rf vendor
      cp -r --reflink=auto "$goModules" vendor

      if [ -n "${modRoot}" ]; then
        popd
      fi
    fi
  else
    echo "goModules is not set or incorrect"
  fi
}

postConfigureHooks+=(goConfigHook)
