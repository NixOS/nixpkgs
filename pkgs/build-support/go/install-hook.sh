goInstallHook() {
  runHook preInstall

  mkdir -p "$out"
  dir="$GOPATH/bin"
  [ -e "$dir" ] && cp -r "$dir" "$out"

  runHook postInstall
}


if [ -z "${dontGoInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=goInstallHook
fi
