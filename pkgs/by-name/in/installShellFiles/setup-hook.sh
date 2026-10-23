# shellcheck shell=bash
# Setup hook for the `installShellFiles` package.
#
# Example usage in a derivation:
#
#   { …, installShellFiles, … }:
#   stdenv.mkDerivation {
#     …
#     nativeBuildInputs = [ installShellFiles ];
#     postInstall = ''
#       installManPage share/doc/foobar.1
#       installShellCompletion share/completions/foobar.{bash,fish,zsh}
#     '';
#     …
#   }
#
# See comments on each function for more details.

# installManPage [--name <path>] <path> [...<path>]
#
# Each argument is checked for its man section suffix and installed into the appropriate
# share/man/man<n>/ directory. The function returns an error if any paths don't have the man
# section suffix (with optional .gz compression).
#
# Optionally accepts pipes as input, which when provided require the `--name` argument to
# name the output file.
#
# installManPage --name foobar.1 <($out/bin/foobar --manpage)
installManPage() {
    local arg name='' continueParsing=1
    while { arg=$1; shift; }; do
        if (( continueParsing )); then
            case "$arg" in
              --name)
                  name=$1
                  shift || {
                      nixErrorLog "${FUNCNAME[0]}: --name flag expected an argument"
                      return 1
                  }
                  continue;;
              --name=*)
                  # Treat `--name=foo` that same as `--name foo`
                  name=${arg#--name=}
                  continue;;
              --)
                  continueParsing=0
                  continue;;
            esac
        fi

        nixInfoLog "${FUNCNAME[0]}: installing $arg${name:+ as $name}"
        local basename

        # Check if path is empty
        if test -z "$arg"; then
            # It is an empty string
            nixErrorLog "${FUNCNAME[0]}: path cannot be empty"
            return 1
        fi

        if test -n "$name"; then
          # Provided name. Required for pipes, optional for paths
          basename=$name
        elif test -p "$arg"; then
            # Named pipe requires a file name
            nixErrorLog "${FUNCNAME[0]}: named pipe requires --name argument"
        else
            # Normal file without a name
            basename=$(stripHash "$arg") # use stripHash in case it's a nix store path
        fi

        # Check that it is well-formed
        local trimmed=${basename%.gz} # don't get fooled by compressed manpages
        local suffix=${trimmed##*.}
        if test -z "$suffix" -o "$suffix" = "$trimmed"; then
            nixErrorLog "${FUNCNAME[0]}: path missing manpage section suffix: $arg"
            return 1
        fi

        # Create the out-path
        local outRoot
        if test "$suffix" = 3; then
            outRoot=${!outputDevman:?}
        else
            outRoot=${!outputMan:?}
        fi
        local outPath="${outRoot}/share/man/man$suffix/"
        nixInfoLog "${FUNCNAME[0]}: installing to $outPath"

        # Install
        if test -p "$arg"; then
          # install doesn't work with pipes on Darwin
          mkdir -p "$outPath" && cat "$arg" > "$outPath/$basename"
        else
          install -D --mode=644 --no-target-directory -- "$arg" "$outPath/$basename"
        fi

        # Reset the name for the next page
        name=
    done
}

# installShellCompletion [--cmd <name>] ([--bash|--fish|--zsh] [--name <name>] <path>)...
#
# Each path is installed into the appropriate directory for shell completions for the given shell.
# If one of `--bash`, `--fish`, `--zsh`, or `--nushell` is given the path is assumed to belong to
# that shell. Otherwise the file extension will be examined to pick a shell. If the shell is
# unknown a warning will be logged and the command will return a non-zero status code after
# processing any remaining paths. Any of the shell flags will affect all subsequent paths (unless
# another shell flag is given).
#
# If the shell completion needs to be renamed before installing the optional `--name <name>` flag
# may be given. Any name provided with this flag only applies to the next path.
#
# If all shell completions need to be renamed before installing the optional `--cmd <name>` flag
# may be given. This will synthesize a name for each file, unless overridden with an explicit
# `--name` flag. For example, `--cmd foobar` will synthesize the name `_foobar` for zsh and
# `foobar.bash` for bash.
#
# For zsh completions, if the `--name` flag is not given, the path will be automatically renamed
# such that `foobar.zsh` becomes `_foobar`.
#
# A path may be a named fd, such as produced by the bash construct `<(cmd)`. When using a named fd,
# the shell type flag must be provided, and either the `--name` or `--cmd` flag must be provided.
# This might look something like:
#
#   installShellCompletion --zsh --name _foobar <($out/bin/foobar --zsh-completion)
#
# This command accepts multiple shell flags in conjunction with multiple paths if you wish to
# install them all in one command:
#
#   installShellCompletion share/completions/foobar.{bash,fish} --zsh share/completions/_foobar
#
# However it may be easier to read if each shell is split into its own invocation, especially when
# renaming is involved:
#
#   installShellCompletion --bash --name foobar.bash share/completions.bash
#   installShellCompletion --fish --name foobar.fish share/completions.fish
#   installShellCompletion --nushell --name foobar share/completions.nu
#   installShellCompletion --zsh --name _foobar share/completions.zsh
#
# Or to use shell newline escaping to split a single invocation across multiple lines:
#
#   installShellCompletion --cmd foobar \
#     --bash <($out/bin/foobar --bash-completion) \
#     --fish <($out/bin/foobar --fish-completion) \
#     --nushell <($out/bin/foobar --nushell-completion)
#     --zsh <($out/bin/foobar --zsh-completion)
#
# If any argument is `--` the remaining arguments will be treated as paths.
installShellCompletion() {
    local shell='' name='' cmdname='' retval=0 parseArgs=1 arg
    while { arg=$1; shift; }; do
        # Parse arguments
        if (( parseArgs )); then
            case "$arg" in
            --bash|--fish|--zsh|--nushell)
                shell=${arg#--}
                continue;;
            --name)
                name=$1
                shift || {
                    nixErrorLog "${FUNCNAME[0]}: --name flag expected an argument"
                    return 1
                }
                continue;;
            --name=*)
                # treat `--name=foo` the same as `--name foo`
                name=${arg#--name=}
                continue;;
            --cmd)
                cmdname=$1
                shift || {
                    nixErrorLog "${FUNCNAME[0]}: --cmd flag expected an argument"
                    return 1
                }
                continue;;
            --cmd=*)
                # treat `--cmd=foo` the same as `--cmd foo`
                cmdname=${arg#--cmd=}
                continue;;
            --?*)
                nixWarnLog "${FUNCNAME[0]}: unknown flag ${arg%%=*}"
                retval=2
                continue;;
            --)
                # treat remaining args as paths
                parseArgs=0
                continue;;
            esac
        fi
        nixInfoLog "${FUNCNAME[0]}: installing $arg${name:+ as $name}"
        # if we get here, this is a path or named pipe
        # Identify shell and output name
        local curShell=$shell
        local outName=''
        if [[ -z "$arg" ]]; then
            nixErrorLog "${FUNCNAME[0]}: empty path is not allowed"
            return 1
        elif [[ -p "$arg" ]]; then
            # this is a named fd or fifo
            if [[ -z "$curShell" ]]; then
                nixErrorLog "${FUNCNAME[0]}: named pipe requires one of --bash, --fish, --zsh, or --nushell"
                return 1
            elif [[ -z "$name" && -z "$cmdname" ]]; then
                nixErrorLog "${FUNCNAME[0]}: named pipe requires one of --cmd or --name"
                return 1
            fi
        else
            # this is a path
            local argbase
            argbase=$(stripHash "$arg")
            if [[ -z "$curShell" ]]; then
                # auto-detect the shell
                case "$argbase" in
                ?*.bash) curShell=bash;;
                ?*.fish) curShell=fish;;
                ?*.nu) curShell=nushell;;
                ?*.zsh) curShell=zsh;;
                *)
                    if [[ "$argbase" = _* && "$argbase" != *.* ]]; then
                        # probably zsh
                        nixWarnLog "${FUNCNAME[0]}: assuming path \`$arg' is zsh; please specify with --zsh"
                        curShell=zsh
                    else
                        nixWarnLog "${FUNCNAME[0]}: unknown shell for path: $arg" >&2
                        retval=2
                        continue
                    fi;;
                esac
            fi
            outName=$argbase
        fi
        # Identify output path
        if [[ -n "$name" ]]; then
            outName=$name
        elif [[ -n "$cmdname" ]]; then
            case "$curShell" in
            bash|fish) outName=$cmdname.$curShell;;
            nushell) outName=$cmdname.nu;;
            zsh) outName=_$cmdname;;
            *)
                # Our list of shells is out of sync with the flags we accept or extensions we detect.
                nixErrorLog "${FUNCNAME[0]}: internal: shell $curShell not recognized"
                return 1;;
            esac
        fi
        local sharePath
        case "$curShell" in
        bash) sharePath=bash-completion/completions;;
        fish) sharePath=fish/vendor_completions.d;;
        nushell) sharePath=nushell/vendor/autoload;;
        zsh)
            sharePath=zsh/site-functions
            # only apply automatic renaming if we didn't have a manual rename
            if [[ -z "$name" && -z "$cmdname" ]]; then
                # convert a name like `foo.zsh` into `_foo`
                outName=${outName%.zsh}
                outName=_${outName#_}
            fi;;
        *)
            # Our list of shells is out of sync with the flags we accept or extensions we detect.
            nixErrorLog "${FUNCNAME[0]}: internal: shell $curShell not recognized"
            return 1;;
        esac
        # Install file
        local outDir="${!outputBin:?}/share/$sharePath"
        local outPath="$outDir/$outName"
        if [[ -p "$arg" ]]; then
            # install handles named pipes on NixOS but not on macOS
            mkdir -p "$outDir" \
            && cat "$arg" > "$outPath"
        else
            install -D --mode=644 --no-target-directory "$arg" "$outPath"
        fi

        if [ ! -s "$outPath" ]; then
            nixErrorLog "${FUNCNAME[0]}: installed shell completion file \`$outPath' does not exist or has zero size"
            return 1
        fi
        # Clear the per-path flags
        name=
    done
    if [[ -n "$name" ]]; then
        nixErrorLog "${FUNCNAME[0]}: --name flag given with no path" >&2
        return 1
    fi
    return $retval
}

# installBin <path> [...<path>]
#
# Install each argument to $outputBin
installBin() {
    local path
    for path in "$@"; do
        if test -z "$path"; then
            nixErrorLog "${FUNCNAME[0]}: path cannot be empty"
            return 1
        fi
        nixInfoLog "${FUNCNAME[0]}: installing $path"

        local basename
        # use stripHash in case it's a nix store path
        basename=$(stripHash "$path")

        local outRoot
        outRoot=${!outputBin:?}

        local outPath="${outRoot}/bin/$basename"
        install -D --mode=755 --no-target-directory "$path" "${outRoot}/bin/$basename"
    done
}
