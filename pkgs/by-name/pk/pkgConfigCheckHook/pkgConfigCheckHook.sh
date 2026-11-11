# shellcheck shell=bash

pkgConfigCheckHook() {
  if [[ -z "${pkgConfigModules[*]-}" ]]; then
    nixErrorLog "pkgConfigModules is empty or unset"
    exit 1
  fi

  # some packages put .pc in $dev, others in $out, and there's probably more
  for output in $(getAllOutputNames); do
    addToSearchPath PKG_CONFIG_PATH "${!output}/lib/pkgconfig"
    addToSearchPath PKG_CONFIG_PATH "${!output}/share/pkgconfig"
  done

  # Module names do not contain spaces
  # shellcheck disable=SC2206,2048
  for moduleName in ${pkgConfigModules[*]-}; do
    if ! moduleVersion="$(@pkgconfig@ --modversion "$moduleName")"; then
      nixErrorLog "pkg-config module $moduleName not found"
      exit 1
    fi
    nixInfoLog "pkg-config module $moduleName has version $moduleVersion"

    if [[ -z "${dontPkgConfigCheckVersion-}" && "$moduleVersion" != "$version" ]]; then
      nixErrorLog "pkg-config module $moduleName has version $moduleVersion, expected $version"
      exit 1
    fi
  done
}

if [[ -z "${dontPkgConfigCheck-}" ]]; then
  echo "Using pkgConfigCheckHook"
  preInstallCheckHooks+=(pkgConfigCheckHook)
fi
