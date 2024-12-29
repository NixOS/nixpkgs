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

# installManPage <path> [...<path>]
#
# Each argument is checked for its man section suffix and installed into the appropriate
# share/man/man<n>/ directory. The function returns an error if any paths don't have the man
# section suffix (with optional .gz compression).
installManPage() {
    local path
    for path in "$@"; do
        if (( "${NIX_DEBUG:-0}" >= 1 )); then
            echo "installManPage: installing $path"
        fi
        if test -z "$path"; then
            echo "installManPage: error: path cannot be empty" >&2
            return 1
        fi
        local basename
        basename=$(stripHash "$path") # use stripHash in case it's a nix store path
        local trimmed=${basename%.gz} # don't get fooled by compressed manpages
        local suffix=${trimmed##*.}
        if test -z "$suffix" -o "$suffix" = "$trimmed"; then
            echo "installManPage: error: path missing manpage section suffix: $path" >&2
            return 1
        fi
        local outRoot
        if test "$suffix" = 3; then
            outRoot=${!outputDevman:?}
        else
            outRoot=${!outputMan:?}
        fi
        install -Dm644 -T "$path" "${outRoot}/share/man/man$suffix/$basename" || return
    done
}

# installShellCompletion [--cmd <name>] ([--bash|--fish|--zsh] [--name <name>] <path>)...
#
# Each path is installed into the appropriate directory for shell completions for the given shell.
# If one of `--bash`, `--fish`, or `--zsh` is given the path is assumed to belong to that shell.
# Otherwise the file extension will be examined to pick a shell. If the shell is unknown a warning
# will be logged and the command will return a non-zero status code after processing any remaining
# paths. Any of the shell flags will affect all subsequent paths (unless another shell flag is
# given).
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
#   installShellCompletion --zsh --name _foobar share/completions.zsh
#
# Or to use shell newline escaping to split a single invocation across multiple lines:
#
#   installShellCompletion --cmd foobar \
#     --bash <($out/bin/foobar --bash-completion) \
#     --fish <($out/bin/foobar --fish-completion) \
#     --zsh <($out/bin/foobar --zsh-completion)
#
# If any argument is `--` the remaining arguments will be treated as paths.
installShellCompletion() {
    local shell='' name='' cmdname='' retval=0 parseArgs=1 arg
    while { arg=$1; shift; }; do
        # Parse arguments
        if (( parseArgs )); then
            case "$arg" in
            --bash|--fish|--zsh)
                shell=${arg#--}
                continue;;
            --name)
                name=$1
                shift || {
                    echo 'installShellCompletion: error: --name flag expected an argument' >&2
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
                    echo 'installShellCompletion: error: --cmd flag expected an argument' >&2
                    return 1
                }
                continue;;
            --cmd=*)
                # treat `--cmd=foo` the same as `--cmd foo`
                cmdname=${arg#--cmd=}
                continue;;
            --?*)
                echo "installShellCompletion: warning: unknown flag ${arg%%=*}" >&2
                retval=2
                continue;;
            --)
                # treat remaining args as paths
                parseArgs=0
                continue;;
            esac
        fi
        if (( "${NIX_DEBUG:-0}" >= 1 )); then
            echo "installShellCompletion: installing $arg${name:+ as $name}"
        fi
        # if we get here, this is a path or named pipe
        # Identify shell and output name
        local curShell=$shell
        local outName=''
        if [[ -z "$arg" ]]; then
            echo "installShellCompletion: error: empty path is not allowed" >&2
            return 1
        elif [[ -p "$arg" ]]; then
            # this is a named fd or fifo
            if [[ -z "$curShell" ]]; then
                echo "installShellCompletion: error: named pipe requires one of --bash, --fish, or --zsh" >&2
                return 1
            elif [[ -z "$name" && -z "$cmdname" ]]; then
                echo "installShellCompletion: error: named pipe requires one of --cmd or --name" >&2
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
                ?*.zsh) curShell=zsh;;
                *)
                    if [[ "$argbase" = _* && "$argbase" != *.* ]]; then
                        # probably zsh
                        echo "installShellCompletion: warning: assuming path \`$arg' is zsh; please specify with --zsh" >&2
                        curShell=zsh
                    else
                        echo "installShellCompletion: warning: unknown shell for path: $arg" >&2
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
            zsh) outName=_$cmdname;;
            *)
                # Our list of shells is out of sync with the flags we accept or extensions we detect.
                echo 'installShellCompletion: internal error' >&2
                return 1;;
            esac
        fi
        local sharePath
        case "$curShell" in
        bash) sharePath=bash-completion/completions;;
        fish) sharePath=fish/vendor_completions.d;;
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
            echo 'installShellCompletion: internal error' >&2
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
            install -Dm644 -T "$arg" "$outPath"
        fi || return

        if [ ! -s "$outPath" ]; then
            echo "installShellCompletion: error: installed shell completion file \`$outPath' does not exist or has zero size" >&2
            return 1
        fi
        # Clear the per-path flags
        name=
    done
    if [[ -n "$name" ]]; then
        echo 'installShellCompletion: error: --name flag given with no path' >&2
        return 1
    fi
    return $retval
}
