# Generate a binary executable wrapper for wrapping an executable.
# The binary is compiled from generated C-code using gcc.
# makeBinaryWrapper EXECUTABLE OUT_PATH ARGS

# ARGS:
# --argv0       NAME    : set name of executed process to NAME
#                         (otherwise it’s called …-wrapped)
# --set         VAR VAL : add VAR with value VAL to the executable’s
#                         environment
# --set-default VAR VAL : like --set, but only adds VAR if not already set in
#                         the environment
# --unset       VAR     : remove VAR from the environment
# --add-flags   FLAGS   : add FLAGS to invocation of executable

# --prefix          ENV SEP VAL   : suffix/prefix ENV with VAL, separated by SEP
# --suffix

# To troubleshoot a binary wrapper after you compiled it,
# use the `strings` command or open the binary file in a text editor.
makeBinaryWrapper() {
    makeDocumentedCWrapper "$1" "${@:3}" | gcc -Os -x c -o "$2" -
}

# Generate source code for the wrapper in such a way that the wrapper source code
# will still be readable even after compilation
# makeDocumentedCWrapper EXECUTABLE ARGS
# ARGS: same as makeBinaryWrapper
makeDocumentedCWrapper() {
    local src=$(makeCWrapper "$@")
    local docs=$(documentationString "$src")
    printf "%s\n" "$src"
    printf "\n%s\n" "$docs"
}

# makeCWrapper EXECUTABLE ARGS
# ARGS: same as makeBinaryWrapper
makeCWrapper() {
    local argv0 n params cmd main flagsBefore flags
    local uses_prefix uses_suffix uses_concat3
    local executable=$(escapeStringLiteral "$1")
    local params=("$@")

    for ((n = 1; n < ${#params[*]}; n += 1)); do
        p="${params[$n]}"
        if [[ "$p" == "--set" ]]; then
            cmd=$(setEnv "${params[$((n + 1))]}" "${params[$((n + 2))]}")
            main="$main    $cmd"$'\n'
            n=$((n + 2))
        elif [[ "$p" == "--set-default" ]]; then
            cmd=$(setDefaultEnv "${params[$((n + 1))]}" "${params[$((n + 2))]}")
            main="$main    $cmd"$'\n'
            n=$((n + 2))
        elif [[ "$p" == "--unset" ]]; then
            cmd=$(unsetEnv "${params[$((n + 1))]}")
            main="$main    $cmd"$'\n'
            n=$((n + 1))
        elif [[ "$p" == "--prefix" ]]; then
            cmd=$(setEnvPrefix "${params[$((n + 1))]}" "${params[$((n + 2))]}" "${params[$((n + 3))]}")
            main="$main    $cmd"$'\n'
            uses_prefix=1
            uses_concat3=1
            n=$((n + 3))
        elif [[ "$p" == "--suffix" ]]; then
            cmd=$(setEnvSuffix "${params[$((n + 1))]}" "${params[$((n + 2))]}" "${params[$((n + 3))]}")
            main="$main    $cmd"$'\n'
            uses_suffix=1
            uses_concat3=1
            n=$((n + 3))
        elif [[ "$p" == "--add-flags" ]]; then
            flags="${params[$((n + 1))]}"
            flagsBefore="$flagsBefore $flags"
            n=$((n + 1))
        elif [[ "$p" == "--argv0" ]]; then
            argv0=$(escapeStringLiteral "${params[$((n + 1))]}")
            n=$((n + 1))
        else
            # Using an error macro, we will make sure the compiler gives an understandable error message
            printf "%s\n" "    #error makeCWrapper did not understand argument ${p}"
        fi
    done
    [ -z "$flagsBefore" ] || main="$main"${main:+$'\n'}$(addFlags $flagsBefore)$'\n'$'\n'
    main="$main    argv[0] = \"${argv0:-${executable}}\";"$'\n'
    main="$main    return execv(\"${executable}\", argv);"$'\n'

    printf "%s\n" "#include <unistd.h>"
    printf "%s\n" "#include <stdlib.h>"
    [ -z "$uses_concat3" ] || printf "%s\n" "#include <string.h>"
    [ -z "$uses_concat3" ] || printf "\n%s\n" "$(concat3Fn)"
    [ -z "$uses_prefix" ]  || printf "\n%s\n" "$(setEnvPrefixFn)"
    [ -z "$uses_suffix" ]  || printf "\n%s\n" "$(setEnvSuffixFn)"
    printf "\n%s" "int main(int argc, char **argv) {"
    printf "\n%s" "$main"
    printf "%s\n" "}"
}

addFlags() {
    local result n flag flags
    local var="argv_tmp"
    flags=("$@")
    for ((n = 0; n < ${#flags[*]}; n += 1)); do
        flag=$(escapeStringLiteral "${flags[$n]}")
        result="$result    $var[$((n+1))] = \"$flag\";"$'\n'
    done
    printf "    %s\n" "char **$var = malloc(sizeof(*$var) * ($((n+1)) + argc));"
    printf "    %s\n" "$var[0] = argv[0];"
    printf "%s" "$result"
    printf "    %s\n" "for (int i = 1; i < argc; ++i) {"
    printf "    %s\n" "    $var[$n + i] = argv[i];"
    printf "    %s\n" "}"
    printf "    %s\n" "$var[$n + argc] = NULL;"
    printf "    %s\n" "argv = $var;"
}

# prefix ENV SEP VAL
setEnvPrefix() {
    local env=$(escapeStringLiteral "$1")
    local sep=$(escapeStringLiteral "$2")
    local val=$(escapeStringLiteral "$3")
    printf "%s" "set_env_prefix(\"$env\", \"$sep\", \"$val\");"
}

# suffix ENV SEP VAL
setEnvSuffix() {
    local env=$(escapeStringLiteral "$1")
    local sep=$(escapeStringLiteral "$2")
    local val=$(escapeStringLiteral "$3")
    printf "%s" "set_env_suffix(\"$env\", \"$sep\", \"$val\");"
}

# setEnv KEY VALUE
setEnv() {
    local key=$(escapeStringLiteral "$1")
    local value=$(escapeStringLiteral "$2")
    printf "%s" "putenv(\"$key=$value\");"
}

# setDefaultEnv KEY VALUE
setDefaultEnv() {
    local key=$(escapeStringLiteral "$1")
    local value=$(escapeStringLiteral "$2")
    printf "%s" "setenv(\"$key\", \"$value\", 0);"
}

# unsetEnv KEY
unsetEnv() {
    local key=$(escapeStringLiteral "$1")
    printf "%s" "unsetenv(\"$key\");"
}

# Put the entire source code into const char* SOURCE_CODE to make it readable after compilation.
# documentationString SOURCE_CODE
documentationString() {
    local docs=$(escapeStringLiteral $'\n----------\n// This binary wrapper was compiled from the following generated C-code:\n'"$1"$'\n----------\n')
    printf "%s" "const char * SOURCE_CODE = \"$docs\";"
}

# Makes it safe to insert STRING within quotes in a C String Literal.
# escapeStringLiteral STRING
escapeStringLiteral() {
    local result
    result=${1//$'\\'/$'\\\\'}
    result=${result//\"/'\"'}
    result=${result//$'\n'/"\n"}
    result=${result//$'\r'/"\r"}
    printf "%s" "$result"
}

concat3Fn() {
    printf "%s\n" 'char *concat3(char *x, char *y, char *z) {'
    printf "%s\n" '    int xn = strlen(x);'
    printf "%s\n" '    int yn = strlen(y);'
    printf "%s\n" '    int zn = strlen(z);'
    printf "%s\n" '    char *res = malloc(sizeof(*res)*(xn + yn + zn + 1));'
    printf "%s\n" '    for (int i = 0; i < xn; ++i) res[i] = x[i];'
    printf "%s\n" '    for (int i = 0; i < yn; ++i) res[xn+i] = y[i];'
    printf "%s\n" '    for (int i = 0; i < zn; ++i) res[xn+yn+i] = z[i];'
    printf "%s\n" "    res[xn+yn+zn] = '\0';"
    printf "%s\n" '    return res;'
    printf "%s\n" '}'
}

setEnvPrefixFn() {
    printf "%s\n" 'void set_env_prefix(char *env, char *sep, char *val) {'
    printf "%s\n" '    char *existing = getenv(env);'
    printf "%s\n" '    if (existing) val = concat3(val, sep, existing);'
    printf "%s\n" '    setenv(env, val, 1);'
    printf "%s\n" '    if (existing) free(val);'
    printf "%s\n" '}'
}

setEnvSuffixFn() {
    printf "%s\n" 'void set_env_suffix(char *env, char *sep, char *val) {'
    printf "%s\n" '    char *existing = getenv(env);'
    printf "%s\n" '    if (existing) val = concat3(existing, sep, val);'
    printf "%s\n" '    setenv(env, val, 1);'
    printf "%s\n" '    if (existing) free(val);'
    printf "%s\n" '}'
}
