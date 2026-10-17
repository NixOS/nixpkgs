# shellcheck shell=bash

pkgConfigCheckHook() {
  if [[ -n "${pkgConfigModules[*]-}" ]]; then
    # some packages put .pc in $dev, others in $out, and there's probably more
    for output in $(getAllOutputNames); do
      addToSearchPath PKG_CONFIG_PATH "${!output}/lib/pkgconfig"
      addToSearchPath PKG_CONFIG_PATH "${!output}/share/pkgconfig"
    done

    # Module names do not contain spaces
    # shellcheck disable=SC2206,2048
    for moduleName in ${pkgConfigModules[*]-}; do
      echo -n "checking pkg-config module $moduleName "
      moduleVersion="$(@pkgconfig@ --modversion "$moduleName")"
      echo "version $moduleVersion"

      if [[ -z "${dontPkgConfigCheckVersion-}" && "$moduleVersion" != "$version" ]]; then
        echo "pkg-config module $moduleName has version $moduleVersion, expected $version" >&2
        exit 1
      fi
    done
  fi
}

if [[ -z "${dontPkgConfigCheck-}" ]]; then
  echo "Using pkgConfigCheckHook"
  preInstallCheckHooks+=(pkgConfigCheckHook)
fi
