# shellcheck shell=bash

denoBuildHook() {
  echo "Executing denoBuildHook"

  runHook preBuild

  if [ -n "${binaryEntrypointPath-}" ]; then
    echo "Creating binary"

    package_name=$(jq -r '.name' deno.json)
    if [ "$package_name" == "null" ]; then
      package_name="$name"
    fi

    deno compile \
      --output "$package_name" \
      --target "$hostPlatform_" \
      $denoCompileFlags \
      $denoFlags \
      "${denoWorkspacePath+$denoWorkspacePath/}$binaryEntrypointPath"
      $extraCompileFlags \

  elif [ -n "${denoTaskScript-}" ]; then
    if ! @denoTaskPrefix@ \
      deno task \
      ${denoWorkspacePath+--cwd=$denoWorkspacePath} \
      $denoTaskFlags \
      $denoFlags \
      "$denoTaskScript" \
      $extraTaskFlags \
      @denoTaskSuffix@; then
      echo
      echo 'ERROR: `deno task` failed'
      echo
      echo "Here are a few things you can try, depending on the error:"
      echo "1. Make sure your task script ($denoTaskScript) exists"
      echo

      exit 1
    fi
  else
    echo
    echo "ERROR: nothing to do in buildPhase"
    echo "Specify either 'binaryEntrypointPath' or 'denoTaskScript' or override 'buildPhase'"
    echo

    exit 1
  fi

  runHook postBuild

  echo "Finished denoBuildHook"
}

if [ -z "${buildPhase-}" ]; then
  buildPhase=denoBuildHook
fi
