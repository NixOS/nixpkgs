if [ "${dontUnpack-}" == "1" ]; then
  # When not unpacking, we assume the source is a TOML file
  # which will not be copied into the cwd of the build phase
  export KALAMINE_KEYMAP_PATH="${src-}"
else
  export KALAMINE_KEYMAP_PATH="."
fi

kalamineBuild() {
  local KEYMAP_PATH="$1"

  if [ -f "${KEYMAP_PATH}" ]; then
    kalamine build "${kalamineBuildArgs[@]}" "${KEYMAP_PATH}"
  elif [ -d "${KEYMAP_PATH}" ]; then
    kalamine build "${kalamineBuildArgs[@]}" "${KEYMAP_PATH}"/*.toml
  fi
}

kalamineBuildPhase() {
  runHook preBuild

  kalamineBuild "${KALAMINE_KEYMAP_PATH}"

  runHook postBuild
}

kalamineInstall() {
  mkdir $out
  mv dist/* $out/
}

kalamineInstallPhase() {
  runHook preInstall

  kalamineInstall

  runHook postInstall
}


if [ "${dontUseKalamineBuild-}" != "1" ]; then
  if [ -z "${buildPhase-}" ]; then
    buildPhase=kalamineBuildPhase
  fi

  if [ -z "${installPhase-}" ]; then
    installPhase=kalamineInstallPhase
  fi
fi
