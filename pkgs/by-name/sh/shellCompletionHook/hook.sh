# shellcheck shell=bash

shellCompletionHook() {
  echo "Executing shellCompletionHook"

  # large parts of this is taken from versionCheckHook
  local cmdProgram cmdArg

  if [[ ! -z "${NIX_MAIN_PROGRAM-}" ]]; then
    cmdProgram="${!outputBin}/bin/${NIX_MAIN_PROGRAM}"
  elif [[ ! -z "${pname-}" ]]; then
    echo "shellCompletionHook: Package \`${pname}\` does not have the \`meta.mainProgram\` attribute." \
      "We'll assume that the main program has the same name for now, but this behavior is deprecated," \
      "because it leads to surprising errors when the assumption does not hold." \
      "If the package has a main program, please set \`meta.mainProgram\` in its definition to make this warning go away." \
    cmdProgram="${!outputBin}/bin/${pname}"
  else
    echo "shellCompletionHook: \$NIX_MAIN_PROGRAM and \$pname are empty, so" \
        "we don't know how to run the shellCompletionHook." \
        "To fix this, set one of \`meta.mainProgram\` or \`pname\`." >&2
    exit 2
  fi


  if [[ ! -x "$cmdProgram" ]]; then
    echo "shellCompletionHook: $cmdProgram was not found, or is not an executable" >&2
    exit 2
  fi

  if [[ -z "${shellCompletionProgramArg}" ]]; then
    for cmdArg in "completion"; do
      ( installShellCompletion --cmd "${cmdProgram##*/}" \
        --bash <("$cmdProgram" $cmdArg bash) \
        --fish <("$cmdProgram" $cmdArg fish) \
        --zsh <("$cmdProgram" $cmdArg zsh) ) && break
    done
  else
    cmdArg="shellCompletionProgramArg"
    installShellCompletion --cmd "$cmdProgram" \
      --bash <("$cmdProgram" $cmdArg --bash) \
      --fish <("$cmdProgram" $cmdArg --fish) \
      --zsh <("$cmdProgram" $cmdArg --zsh) && break
    exit 2
  fi

  echo "Finished shellCompletionHook"
}

postInstallHooks+=(shellCompletionHook)
