
set -euo pipefail

# Assert that FILE exists and is executable
#
# assertExecutable FILE
assertExecutable() {
    local file="$1"
    [[ -f "$file" && -x "$file" ]] || \
        die "Cannot wrap '$file' because it is not an executable file"
}

# Generate a binary executable wrapper for wrapping an executable.
# The binary is compiled from generated C-code using gcc.
# makeWrapper EXECUTABLE OUT_PATH ARGS

# ARGS:
# --argv0        NAME    : set the name of the executed process to NAME
#                          (if unset or empty, defaults to EXECUTABLE)
# --inherit-argv0        : the executable inherits argv0 from the wrapper.
#                          (use instead of --argv0 '$0')
# --set          VAR VAL : add VAR with value VAL to the executable's environment
# --set-default  VAR VAL : like --set, but only adds VAR if not already set in
#                          the environment
# --unset        VAR     : remove VAR from the environment
# --chdir        DIR     : change working directory (use instead of --run "cd DIR")
# --add-flags    ARGS    : prepend ARGS to the invocation of the executable
#                          (that is, *before* any arguments passed on the command line)
# --append-flags ARGS    : append ARGS to the invocation of the executable
#                          (that is, *after* any arguments passed on the command line)

# --prefix          ENV SEP VAL   : suffix/prefix ENV with VAL, separated by SEP
# --suffix

# To troubleshoot a binary wrapper after you compiled it,
# use the `strings` command or open the binary file in a text editor.
makeWrapper() { makeBinaryWrapper "$@"; }
makeBinaryWrapper() {
    local NIX_CFLAGS_COMPILE= NIX_CFLAGS_LINK=
    local original="$1"
    local wrapper="$2"
    shift 2

    assertExecutable "$original"

    mkdir -p "$(dirname "$wrapper")"

    makeDocumentedCWrapper "$original" "$@" | \
      @cc@ \
        -Wall -Werror -Wpedantic \
        -Wno-overlength-strings \
        -Os \
        -x c \
        -o "$wrapper" -
}

# Syntax: wrapProgram <PROGRAM> <MAKE-WRAPPER FLAGS...>
wrapProgram() { wrapProgramBinary "$@"; }
wrapProgramBinary() {
    local prog="$1"
    local hidden

    assertExecutable "$prog"

    hidden="$(dirname "$prog")/.$(basename "$prog")"-wrapped
    while [ -e "$hidden" ]; do
      hidden="${hidden}_"
    done
    mv "$prog" "$hidden"
    makeBinaryWrapper "$hidden" "$prog" --inherit-argv0 "${@:2}"
}

# Generate source code for the wrapper in such a way that the wrapper inputs
# will still be readable even after compilation
# makeDocumentedCWrapper EXECUTABLE ARGS
# ARGS: same as makeWrapper
makeDocumentedCWrapper() {
    local src docs
    src=$(makeCWrapper "$@")
    docs=$(docstring "$@")
    printf '%s\n\n' "$src"
    printf '%s\n' "$docs"
}

# makeCWrapper EXECUTABLE ARGS
# ARGS: same as makeWrapper
makeCWrapper() {
    local argv0 inherit_argv0 n params cmd main flagsBefore flagsAfter flags executable length
    local uses_prefix uses_suffix uses_assert uses_assert_success uses_stdio uses_asprintf
    executable=$(escapeStringLiteral "$1")
    params=("$@")
    length=${#params[*]}
    for ((n = 1; n < length; n += 1)); do
        p="${params[n]}"
        case $p in
            --set)
                cmd=$(setEnv "${params[n + 1]}" "${params[n + 2]}")
                main="$main$cmd"$'\n'
                n=$((n + 2))
                [ $n -ge "$length" ] && main="$main#error makeCWrapper: $p takes 2 arguments"$'\n'
            ;;
            --set-default)
                cmd=$(setDefaultEnv "${params[n + 1]}" "${params[n + 2]}")
                main="$main$cmd"$'\n'
                uses_stdio=1
                uses_assert_success=1
                n=$((n + 2))
                [ $n -ge "$length" ] && main="$main#error makeCWrapper: $p takes 2 arguments"$'\n'
            ;;
            --unset)
                cmd=$(unsetEnv "${params[n + 1]}")
                main="$main$cmd"$'\n'
                uses_stdio=1
                uses_assert_success=1
                n=$((n + 1))
                [ $n -ge "$length" ] && main="$main#error makeCWrapper: $p takes 1 argument"$'\n'
            ;;
            --prefix)
                cmd=$(setEnvPrefix "${params[n + 1]}" "${params[n + 2]}" "${params[n + 3]}")
                main="$main$cmd"$'\n'
                uses_prefix=1
                uses_asprintf=1
                uses_stdio=1
                uses_assert_success=1
                uses_assert=1
                n=$((n + 3))
                [ $n -ge "$length" ] && main="$main#error makeCWrapper: $p takes 3 arguments"$'\n'
            ;;
            --suffix)
                cmd=$(setEnvSuffix "${params[n + 1]}" "${params[n + 2]}" "${params[n + 3]}")
                main="$main$cmd"$'\n'
                uses_suffix=1
                uses_asprintf=1
                uses_stdio=1
                uses_assert_success=1
                uses_assert=1
                n=$((n + 3))
                [ $n -ge "$length" ] && main="$main#error makeCWrapper: $p takes 3 arguments"$'\n'
            ;;
            --chdir)
                cmd=$(changeDir "${params[n + 1]}")
                main="$main$cmd"$'\n'
                uses_stdio=1
                uses_assert_success=1
                n=$((n + 1))
                [ $n -ge "$length" ] && main="$main#error makeCWrapper: $p takes 1 argument"$'\n'
            ;;
            --add-flags)
                flags="${params[n + 1]}"
                flagsBefore="$flagsBefore $flags"
                uses_assert=1
                n=$((n + 1))
                [ $n -ge "$length" ] && main="$main#error makeCWrapper: $p takes 1 argument"$'\n'
            ;;
            --append-flags)
                flags="${params[n + 1]}"
                flagsAfter="$flagsAfter $flags"
                uses_assert=1
                n=$((n + 1))
                [ $n -ge "$length" ] && main="$main#error makeCWrapper: $p takes 1 argument"$'\n'
            ;;
            --argv0)
                argv0=$(escapeStringLiteral "${params[n + 1]}")
                inherit_argv0=
                n=$((n + 1))
                [ $n -ge "$length" ] && main="$main#error makeCWrapper: $p takes 1 argument"$'\n'
            ;;
            --inherit-argv0)
                # Whichever comes last of --argv0 and --inherit-argv0 wins
                inherit_argv0=1
            ;;
            *) # Using an error macro, we will make sure the compiler gives an understandable error message
                main="$main#error makeCWrapper: Unknown argument ${p}"$'\n'
            ;;
        esac
    done
    [[ -z "$flagsBefore" && -z "$flagsAfter" ]] || main="$main"${main:+$'\n'}$(addFlags "$flagsBefore" "$flagsAfter")$'\n'$'\n'
    [ -z "$inherit_argv0" ] && main="${main}argv[0] = \"${argv0:-${executable}}\";"$'\n'
    main="${main}return execv(\"${executable}\", argv);"$'\n'

    [ -z "$uses_asprintf" ] || printf '%s\n' "#define _GNU_SOURCE         /* See feature_test_macros(7) */"
    printf '%s\n' "#include <unistd.h>"
    printf '%s\n' "#include <stdlib.h>"
    [ -z "$uses_assert" ]   || printf '%s\n' "#include <assert.h>"
    [ -z "$uses_stdio" ]    || printf '%s\n' "#include <stdio.h>"
    [ -z "$uses_assert_success" ] || printf '\n%s\n' "#define assert_success(e) do { if ((e) < 0) { perror(#e); abort(); } } while (0)"
    [ -z "$uses_prefix" ] || printf '\n%s\n' "$(setEnvPrefixFn)"
    [ -z "$uses_suffix" ] || printf '\n%s\n' "$(setEnvSuffixFn)"
    printf '\n%s' "int main(int argc, char **argv) {"
    printf '\n%s' "$(indent4 "$main")"
    printf '\n%s\n' "}"
}

addFlags() {
    local n flag before after var

    # Disable file globbing, since bash will otherwise try to find
    # filenames matching the the value to be prefixed/suffixed if
    # it contains characters considered wildcards, such as `?` and
    # `*`. We want the value as is, except we also want to split
    # it on on the separator; hence we can't quote it.
    local reenableGlob=0
    if [[ ! -o noglob ]]; then
        reenableGlob=1
    fi
    set -o noglob
    # shellcheck disable=SC2086
    before=($1) after=($2)
    if (( reenableGlob )); then
        set +o noglob
    fi

    var="argv_tmp"
    printf '%s\n' "char **$var = calloc(${#before[@]} + argc + ${#after[@]} + 1, sizeof(*$var));"
    printf '%s\n' "assert($var != NULL);"
    printf '%s\n' "${var}[0] = argv[0];"
    for ((n = 0; n < ${#before[@]}; n += 1)); do
        flag=$(escapeStringLiteral "${before[n]}")
        printf '%s\n' "${var}[$((n + 1))] = \"$flag\";"
    done
    printf '%s\n' "for (int i = 1; i < argc; ++i) {"
    printf '%s\n' "    ${var}[${#before[@]} + i] = argv[i];"
    printf '%s\n' "}"
    for ((n = 0; n < ${#after[@]}; n += 1)); do
        flag=$(escapeStringLiteral "${after[n]}")
        printf '%s\n' "${var}[${#before[@]} + argc + $n] = \"$flag\";"
    done
    printf '%s\n' "${var}[${#before[@]} + argc + ${#after[@]}] = NULL;"
    printf '%s\n' "argv = $var;"
}

# chdir DIR
changeDir() {
    local dir
    dir=$(escapeStringLiteral "$1")
    printf '%s' "assert_success(chdir(\"$dir\"));"
}

# prefix ENV SEP VAL
setEnvPrefix() {
    local env sep val
    env=$(escapeStringLiteral "$1")
    sep=$(escapeStringLiteral "$2")
    val=$(escapeStringLiteral "$3")
    printf '%s' "set_env_prefix(\"$env\", \"$sep\", \"$val\");"
    assertValidEnvName "$1"
}

# suffix ENV SEP VAL
setEnvSuffix() {
    local env sep val
    env=$(escapeStringLiteral "$1")
    sep=$(escapeStringLiteral "$2")
    val=$(escapeStringLiteral "$3")
    printf '%s' "set_env_suffix(\"$env\", \"$sep\", \"$val\");"
    assertValidEnvName "$1"
}

# setEnv KEY VALUE
setEnv() {
    local key value
    key=$(escapeStringLiteral "$1")
    value=$(escapeStringLiteral "$2")
    printf '%s' "putenv(\"$key=$value\");"
    assertValidEnvName "$1"
}

# setDefaultEnv KEY VALUE
setDefaultEnv() {
    local key value
    key=$(escapeStringLiteral "$1")
    value=$(escapeStringLiteral "$2")
    printf '%s' "assert_success(setenv(\"$key\", \"$value\", 0));"
    assertValidEnvName "$1"
}

# unsetEnv KEY
unsetEnv() {
    local key
    key=$(escapeStringLiteral "$1")
    printf '%s' "assert_success(unsetenv(\"$key\"));"
    assertValidEnvName "$1"
}

# Makes it safe to insert STRING within quotes in a C String Literal.
# escapeStringLiteral STRING
escapeStringLiteral() {
    local result
    result=${1//$'\\'/$'\\\\'}
    result=${result//\"/'\"'}
    result=${result//$'\n'/"\n"}
    result=${result//$'\r'/"\r"}
    printf '%s' "$result"
}

# Indents every non-empty line by 4 spaces. To avoid trailing whitespace, we don't indent empty lines
# indent4 TEXT_BLOCK
indent4() {
    printf '%s' "$1" | awk '{ if ($0 != "") { print "    "$0 } else { print $0 }}'
}

assertValidEnvName() {
    case "$1" in
        *=*) printf '\n%s\n' "#error Illegal environment variable name \`$1\` (cannot contain \`=\`)";;
        "")  printf '\n%s\n' "#error Environment variable name can't be empty.";;
    esac
}

setEnvPrefixFn() {
    printf '%s' "\
void set_env_prefix(char *env, char *sep, char *prefix) {
    char *existing = getenv(env);
    if (existing) {
        char *val;
        assert_success(asprintf(&val, \"%s%s%s\", prefix, sep, existing));
        assert_success(setenv(env, val, 1));
        free(val);
    } else {
        assert_success(setenv(env, prefix, 1));
    }
}
"
}

setEnvSuffixFn() {
    printf '%s' "\
void set_env_suffix(char *env, char *sep, char *suffix) {
    char *existing = getenv(env);
    if (existing) {
        char *val;
        assert_success(asprintf(&val, \"%s%s%s\", existing, sep, suffix));
        assert_success(setenv(env, val, 1));
        free(val);
    } else {
        assert_success(setenv(env, suffix, 1));
    }
}
"
}

# Embed a C string which shows up as readable text in the compiled binary wrapper,
# giving instructions for recreating the wrapper.
# Keep in sync with makeBinaryWrapper.extractCmd
docstring() {
    printf '%s' "const char * DOCSTRING = \"$(escapeStringLiteral "


# ------------------------------------------------------------------------------------
# The C-code for this binary wrapper has been generated using the following command:


makeCWrapper $(formatArgs "$@")


# (Use \`nix-shell -p makeBinaryWrapper\` to get access to makeCWrapper in your shell)
# ------------------------------------------------------------------------------------


")\";"
}

# formatArgs EXECUTABLE ARGS
formatArgs() {
    printf '%s' "${1@Q}"
    shift
    while [ $# -gt 0 ]; do
        case "$1" in
            --set)
                formatArgsLine 2 "$@"
                shift 2
            ;;
            --set-default)
                formatArgsLine 2 "$@"
                shift 2
            ;;
            --unset)
                formatArgsLine 1 "$@"
                shift 1
            ;;
            --prefix)
                formatArgsLine 3 "$@"
                shift 3
            ;;
            --suffix)
                formatArgsLine 3 "$@"
                shift 3
            ;;
            --chdir)
                formatArgsLine 1 "$@"
                shift 1
            ;;
            --add-flags)
                formatArgsLine 1 "$@"
                shift 1
            ;;
            --append-flags)
                formatArgsLine 1 "$@"
                shift 1
            ;;
            --argv0)
                formatArgsLine 1 "$@"
                shift 1
            ;;
            --inherit-argv0)
                formatArgsLine 0 "$@"
            ;;
        esac
        shift
    done
    printf '%s\n' ""
}

# formatArgsLine ARG_COUNT ARGS
formatArgsLine() {
    local ARG_COUNT LENGTH
    ARG_COUNT=$1
    LENGTH=$#
    shift
    printf '%s' $' \\\n    '"$1"
    shift
    while [ "$ARG_COUNT" -gt $((LENGTH - $# - 2)) ]; do
        printf ' %s' "${1@Q}"
        shift
    done
}
