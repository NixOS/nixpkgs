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
#     postInstall = ''
#       generateShellCompletions -- completion {shell}
#     '';
#     meta.mainProgram = "foobar";
#   }
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
# The build fails if the program exits with a non-zero status or prints
# nothing.  When the build platform cannot execute the programs of the package,
# the arguments are still checked, but the program is not run and no
# completions are installed.

# The platform check below is only valid for a native build input, so refuse
# to load from any other position.
if [[ "${hostOffset-}" != -1 || "${targetOffset-}" != 0 ]]; then
    nixErrorLog "generateShellCompletions must be in nativeBuildInputs (hostOffset=${hostOffset-unset}, targetOffset=${targetOffset-unset})"
    return 1
fi

# Whether the build platform can execute programs built for the host platform
_generateShellCompletionsCanExecute=@canExecuteHost@

generateShellCompletions() {
    local program=${NIX_MAIN_PROGRAM-} cmd='' shells='bash fish zsh'
    local -a envs=() args=()
    while (($#)); do
        case "$1" in
        --program=* | --cmd=* | --shells=* | --env=*)
            set -- "${1%%=*}" "${1#*=}" "${@:2}"
            continue
            ;;
        --program | --cmd | --shells | --env)
            if (($# < 2)); then
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
            args=("$@")
            break
            ;;
        -*)
            nixErrorLog "unknown option $1; pass the arguments of the program after --"
            return 1
            ;;
        *)
            args=("$@")
            break
            ;;
        esac
    done

    local -a shellList
    read -ra shellList <<<"$shells"
    if ((${#shellList[@]} == 0)); then
        nixErrorLog "--shells needs at least one shell"
        return 1
    fi
    local shell
    for shell in "${shellList[@]}"; do
        case "$shell" in
        bash | fish | nushell | zsh) ;;
        *)
            nixErrorLog "unsupported shell $shell; expected bash, fish, nushell or zsh"
            return 1
            ;;
        esac
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
        nixErrorLog "no program to run; set meta.mainProgram or pass --program"
        return 1
    fi
    local binDir=${!outputBin:?}/bin
    if [[ "$program" != */* ]]; then
        program=$binDir/$program
    fi
    if [[ ! -f "$program" || ! -x "$program" ]]; then
        nixErrorLog "$program does not exist or is not executable"
        return 1
    fi

    cmd=${cmd:-${program##*/}}
    if [[ ! -f "$binDir/$cmd" || ! -x "$binDir/$cmd" ]]; then
        nixErrorLog "no executable named $cmd in $binDir; bash and fish load completions by command name, so pass that name with --cmd"
        return 1
    fi

    if [[ "$_generateShellCompletionsCanExecute" != true ]]; then
        nixLog "not generating $cmd completions, because the build platform cannot execute the programs of the package"
        return 0
    fi

    local tmp script
    local -a shellArgs
    tmp=$(mktemp -d)
    for shell in "${shellList[@]}"; do
        shellArgs=("${args[@]//"{shell}"/$shell}")
        script=$tmp/$cmd.$shell
        nixInfoLog "running $program ${shellArgs[*]}"
        if ! (
            for env in "${envs[@]}"; do
                export "${env//"{shell}"/$shell}"
            done
            exec "$program" "${shellArgs[@]}"
        ) </dev/null >"$script"; then
            nixErrorLog "generating $shell completions failed: $program ${shellArgs[*]}"
            rm -rf "$tmp"
            return 1
        fi
        installShellCompletion --cmd "$cmd" "--$shell" "$script" || {
            rm -rf "$tmp"
            return 1
        }
    done
    rm -rf "$tmp"
}
