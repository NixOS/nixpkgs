# shellcheck shell=bash

# Setup hook that generates shell completion scripts by running a program the
# package installs, and installs them with installShellCompletion.
#
# Example usage in a derivation:
#
#   { ..., generateShellCompletions, ... }:
#   stdenv.mkDerivation {
#     ...
#     nativeBuildInputs = [ generateShellCompletions ];
#     generateShellCompletionsArgs = [ "completion" "{shell}" ];
#     meta.mainProgram = "foobar";
#   }
#
# After postInstall, the hook calls generateShellCompletions with these
# attributes of the derivation, if generateShellCompletionsArgs or
# generateShellCompletionsEnv is set:
#
#   generateShellCompletionsArgs     List of arguments, for <arg>
#   generateShellCompletionsEnv      List of <name>=<value>, for --env
#   generateShellCompletionsProgram  Program, for --program
#   generateShellCompletionsCmd      Command, for --cmd
#   generateShellCompletionsShells   List of shells, for --shells
#
# Set these attributes or call generateShellCompletions yourself, not both.  The
# build fails if generateShellCompletions never runs.  Setting
# dontGenerateShellCompletions turns off the call after postInstall, this
# check, and the check against calls next to the attributes.  The check that
# generateShellCompletions ran happens after postFixup, so it is skipped when
# fixupPhase does not run, as with dontFixup or buildCommand.
#
# generateShellCompletions [--program <path>] [--cmd <name>] [--shells <list>]
#                          [--env <name>=<value>]... [--] [<arg>...]
#
# Runs the program once for each shell and installs what it prints on stdout as
# that shell's completion script.  Each `{shell}` in the arguments and in the
# --env values is replaced with the name of the shell: bash, fish, nushell or
# zsh.
#
#   --program  Program to run, as a path or as a name in $outputBin/bin.
#              Defaults to meta.mainProgram.
#   --cmd      Command the completions are for.  It must name an executable in
#              $outputBin/bin, because bash and fish load completions by
#              command name.  Defaults to the name of the program.
#   --shells   Space-separated list of shells.  Defaults to "bash fish zsh".
#   --env      Environment variable to set for the program, for example
#              `--env COMPLETE={shell}` for clap or
#              `--env _FOOBAR_COMPLETE={shell}_source` for click.
#
# The build fails if the program exits with a non-zero status, prints nothing,
# or prints the same script for fish or nushell as for another shell.  When the
# build platform cannot execute the programs of the package, the arguments are
# still checked, but the program is not run and no completions are installed.

# The platform check below is only valid for a native build input, so refuse
# to load from any other position.
if [[ "${hostOffset-}" != -1 || "${targetOffset-}" != 0 ]]; then
  nixErrorLog "generateShellCompletions must be in nativeBuildInputs (hostOffset=${hostOffset-unset}, targetOffset=${targetOffset-unset})"
  return 1
fi

# Whether the build platform can execute programs built for the host platform
_generateShellCompletionsCanExecute=@canExecuteHost@

# Extension of programs built for the host platform, such as .exe for Windows
_generateShellCompletionsExecutableExtension=@hostExecutableExtension@

# Whether generateShellCompletions was called, either explicitly or after
# postInstall
_generateShellCompletionsCalled=

# Whether the postInstall hooks ran, to tell why generateShellCompletions never
# ran
_generateShellCompletionsPostInstallRan=

# Succeeds if any of the named attributes is set
_generateShellCompletionsHasAttrs() {
  local -a values=()
  # Failure means an attribute of the wrong type, such as an attribute set,
  # which is still set, so the error that concatTo prints would only mislead
  concatTo values "$@" 2>/dev/null || return 0
  ((${#values[@]}))
}

# Succeeds if the path, with or without the extension of programs built for the
# host platform, is an executable file
_generateShellCompletionsIsExecutable() {
  local path
  for path in "$1" "$1$_generateShellCompletionsExecutableExtension"; do
    if [[ -f "$path" && -x "$path" ]]; then
      return 0
    fi
  done
  return 1
}

generateShellCompletions() {
  # Explicit call next to the attributes would make one of them meaningless
  if [[ -z "${_generateShellCompletionsAttrsCall-}" && -z "${dontGenerateShellCompletions-}" ]] &&
    _generateShellCompletionsHasAttrs generateShellCompletions{Args,Env,Program,Cmd,Shells}; then
    nixErrorLog "generateShellCompletions was called, but generateShellCompletions* attributes are set; use either the attributes or calls"
    return 1
  fi
  _generateShellCompletionsCalled=1
  # Default splitting, whatever IFS earlier code left behind
  local IFS=$' \t\n'
  local program=${NIX_MAIN_PROGRAM-} cmd='' shells='bash fish zsh'
  local -a envs=()
  while (($#)); do
    case "$1" in
    --program=* | --cmd=* | --shells=* | --env=*)
      set -- "${1%%=*}" "${1#*=}" "${@:2}"
      continue
      ;;
    --program | --cmd | --shells | --env)
      if [[ -z "${2-}" ]]; then
        nixErrorLog "$1 expects an argument"
        return 1
      fi
      case "$1" in
      --program) program=$2 ;;
      --cmd) cmd=$2 ;;
      --shells) shells=$2 ;;
      --env) envs+=("$2") ;;
      esac
      shift 2
      ;;
    --)
      shift
      break
      ;;
    -*)
      nixErrorLog "unknown option $1; pass the arguments of the program after --"
      return 1
      ;;
    *)
      break
      ;;
    esac
  done
  local -a args=("$@")

  local -a shellList=()
  concatTo shellList shells
  if ((${#shellList[@]} == 0)); then
    nixErrorLog "--shells needs at least one shell"
    return 1
  fi
  # Not named shell, because stdenv exports shell, and a local of that name
  # would replace its value in the environment of the program
  local shellName
  local -A seenShells=()
  for shellName in "${shellList[@]}"; do
    case "$shellName" in
    bash | fish | nushell | zsh) ;;
    *)
      nixErrorLog "unsupported shell $shellName; expected bash, fish, nushell or zsh"
      return 1
      ;;
    esac
    if [[ -n "${seenShells[$shellName]-}" ]]; then
      nixErrorLog "shell $shellName is listed more than once"
      return 1
    fi
    seenShells[$shellName]=1
  done

  local env
  for env in "${envs[@]}"; do
    if [[ ! "$env" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
      nixErrorLog "--env expects <name>=<value>, got $env"
      return 1
    fi
  done

  if ((${#shellList[@]} > 1)) && [[ "${args[*]} ${envs[*]}" != *"{shell}"* ]]; then
    nixErrorLog "neither the arguments nor the --env values contain {shell}, so every shell would get the same script"
    return 1
  fi

  if [[ -z "$program" ]]; then
    if [[ -n "${_generateShellCompletionsAttrsCall-}" ]]; then
      nixErrorLog "no program to run; set meta.mainProgram or generateShellCompletionsProgram"
    else
      nixErrorLog "no program to run; set meta.mainProgram or pass --program"
    fi
    return 1
  fi
  local binDir=${!outputBin:?}/bin
  if [[ "$program" != */* ]]; then
    program=$binDir/$program
  fi
  if ! _generateShellCompletionsIsExecutable "$program"; then
    nixErrorLog "$program does not exist or is not executable"
    return 1
  fi

  cmd=${cmd:-${program##*/}}
  if [[ "$cmd" == */* ]]; then
    nixErrorLog "--cmd expects a command name, not a path, got $cmd"
    return 1
  fi
  if ! _generateShellCompletionsIsExecutable "$binDir/$cmd"; then
    local advice='pass that name with --cmd'
    if [[ -n "${_generateShellCompletionsAttrsCall-}" ]]; then
      advice='set generateShellCompletionsCmd to that name'
    fi
    nixErrorLog "no executable named $cmd in $binDir; bash and fish load completions by command name, so $advice"
    return 1
  fi

  if [[ "$_generateShellCompletionsCanExecute" != true ]]; then
    nixLog "not generating $cmd completions, because the build platform cannot execute the programs of the package"
    return 0
  fi

  local tmp script invocation status previous
  local -a shellArgs shellEnvs generated=()
  tmp=$(mktemp -d)
  for shellName in "${shellList[@]}"; do
    script=$tmp/$shellName
    shellArgs=("${args[@]//"{shell}"/$shellName}")
    shellEnvs=("${envs[@]//"{shell}"/$shellName}")
    # Command line for the log, with the variables in front
    printf -v invocation '%q ' "${shellEnvs[@]}" "$program" "${shellArgs[@]}"
    invocation=${invocation% }
    nixInfoLog "running $invocation"
    # Expand the command and the variables before exporting any of them, so
    # that a variable named like a local of this function, such as program or
    # cmd, cannot change the command or the other variables.
    if ! (
      set -- "$program" "${shellArgs[@]}"
      if ((${#shellEnvs[@]})); then
        export "${shellEnvs[@]}"
      fi
      exec -- "$@"
    ) </dev/null >"$script"; then
      nixErrorLog "generating $shellName completions failed: $invocation"
      return 1
    fi
    if [[ ! -s "$script" ]]; then
      nixErrorLog "generating $shellName completions printed nothing: $invocation"
      return 1
    fi
    # Scripts for fish and nushell never fit another shell, so a copy of another
    # shell's script means that the program ignored {shell}.  Bash and zsh may
    # share one, as with argcomplete.
    for previous in "${generated[@]}"; do
      if [[ "$shellName" == @(fish|nushell) || "$previous" == @(fish|nushell) ]] &&
        cmp -s "$tmp/$previous" "$script"; then
        nixErrorLog "generating $shellName completions printed the same script as for $previous, so the program ignores {shell}: $invocation"
        return 1
      fi
    done
    generated+=("$shellName")
    # Not in a condition, so that errexit still applies inside
    # installShellCompletion, which does not check whether install succeeds.
    # Without errexit, as when the caller tests the result, the status is passed
    # on below.
    installShellCompletion --cmd "$cmd" "--$shellName" "$script"
    status=$?
    if ((status)); then
      return "$status"
    fi
  done
  rm -rf "$tmp"
}

# Calls generateShellCompletions with the generateShellCompletions* attributes
# of the derivation, if they are set
_generateShellCompletionsFromAttrs() {
  _generateShellCompletionsPostInstallRan=1
  # Default splitting, whatever IFS earlier code left behind
  local IFS=$' \t\n'
  local -a args=() envs=() shells=() options=()
  concatTo args generateShellCompletionsArgs
  concatTo envs generateShellCompletionsEnv
  if ((${#args[@]} + ${#envs[@]} == 0)); then
    return 0
  fi
  concatTo shells generateShellCompletionsShells
  if [[ -n "${generateShellCompletionsProgram-}" ]]; then
    options+=(--program "$generateShellCompletionsProgram")
  fi
  if [[ -n "${generateShellCompletionsCmd-}" ]]; then
    options+=(--cmd "$generateShellCompletionsCmd")
  fi
  if ((${#shells[@]})); then
    options+=(--shells "${shells[*]}")
  fi
  options+=("${envs[@]/#/--env=}")
  local _generateShellCompletionsAttrsCall=1
  generateShellCompletions "${options[@]}" -- "${args[@]}"
}

# Fails the build when the hook was added but generateShellCompletions never
# ran, for example because the attributes are missing
_generateShellCompletionsCheckCalled() {
  if [[ -n "$_generateShellCompletionsCalled" ]]; then
    return 0
  fi
  # Both the attributes and calls in postInstall need runHook postInstall
  if [[ -z "$_generateShellCompletionsPostInstallRan" ]]; then
    nixErrorLog "generateShellCompletions never ran, and neither did postInstall; make sure that installPhase runs runHook postInstall"
  elif _generateShellCompletionsHasAttrs generateShellCompletions{Program,Cmd,Shells}; then
    nixErrorLog "generateShellCompletions never ran, because neither generateShellCompletionsArgs nor generateShellCompletionsEnv is set; for a program that takes neither, drop the other attributes and call generateShellCompletions"
  else
    nixErrorLog "generateShellCompletions never ran; set generateShellCompletionsArgs or generateShellCompletionsEnv, call generateShellCompletions outside a subshell, or set dontGenerateShellCompletions"
  fi
  return 1
}

if [[ -z "${dontGenerateShellCompletions-}" ]]; then
  postInstallHooks+=(_generateShellCompletionsFromAttrs)
  postFixupHooks+=(_generateShellCompletionsCheckCalled)
fi
