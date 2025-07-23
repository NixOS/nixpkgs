# shellcheck shell=bash

denoInstallHook() {
  echo "Executing denoInstallHook"

  runHook preInstall

  if [ -n "${binaryEntrypointPath-}" ]; then
    package_name=$(jq -r '.name' deno.json)
    if [ "$package_name" == "null" ]; then
      package_name="$name"
    fi

    mkdir -p "$out/bin"
    cp "$package_name"* "$out/bin"
  else
    echo
    echo "ERROR: nothing to do in installPhase"
    echo "Specify either 'binaryEntrypointPath' or override 'installPhase'"
    echo

    exit 1
  fi

  runHook postInstall

  echo "Finished denoInstallHook"
}

if [ -z "${dontDenoInstall-}" ] && [ -z "${installPhase-}" ]; then
  installPhase=denoInstallHook
fi
