#!/bin/bash
# make-c-wrapper.sh EXECUTABLE ARGS
#
# ARGS:
# --argv0       NAME    : set name of executed process to NAME
#                         (defaults to EXECUTABLE)
# --set         VAR VAL : add VAR with value VAL to the executable’s
#                         environment
# --set-default VAR VAL : like --set, but only adds VAR if not already set in
#                         the environment
# --unset       VAR     : remove VAR from the environment
#
# To debug a binary wrapper after you compiled it, use the `strings` command

escape_string_literal() {
    # We need to make sure that special characters are escaped 
    # before trying to create C string literals
    result=${1//$'\\'/$'\\\\'}
    result=${result//\"/'\"'}
    result=${result//$'\n'/"\n"}
    result=${result//$'\r'/"\r"}
}

escape_string_literal "$1"
executable="${result}"
args=("$@")

printf "%s\n" "#include <unistd.h>"
printf "%s\n" "#include <stdlib.h>"
printf "\n%s\n" "int main(int argc, char **argv) {"
for ((n = 1; n < ${#args[*]}; n += 1)); do
    p="${args[$n]}"
    if [[ "$p" == "--set" ]]; then
        escape_string_literal "${args[$((n + 1))]}"
        key="${result}"
        escape_string_literal "${args[$((n + 2))]}"
        value="${result}"
        n=$((n + 2))
        printf "%s\n" "    putenv(\"${key}=${value}\");"
        docs="${docs:+$docs$'\n'}putenv(\"${key}=${value}\");"
    elif [[ "$p" == "--set-default" ]]; then
        escape_string_literal "${args[$((n + 1))]}"
        key="${result}"
        escape_string_literal "${args[$((n + 2))]}"
        value="${result}"
        n=$((n + 2))
        printf "%s\n" "    setenv(\"${key}\", \"${value}\", 0);"
        docs="${docs:+$docs$'\n'}setenv(\"${key}=${value}\", 0);"
    elif [[ "$p" == "--unset" ]]; then
        escape_string_literal "${args[$((n + 1))]}"
        key="${result}"
        printf "%s\n" "    unsetenv(\"$key\");"
        docs="${docs:+$docs$'\n'}unsetenv(\"${key}=${value}\", 0);"
        n=$((n + 1))
    elif [[ "$p" == "--argv0" ]]; then
        escape_string_literal "${args[$((n + 1))]}"
        argv0="${result}"
        n=$((n + 1))
    else
        # Using an error macro, we will make sure the compiler gives an understandable error message
        printf "%s\n" "    #error make-c-wrapper.sh did not understand argument ${p}"
    fi
done
printf "%s\n" "    argv[0] = \"${argv0:-${executable}}\";"
printf "%s\n" "    return execv(\"${executable}\", argv);"
printf "%s\n" "}"

docs="${docs:+$docs$'\n'}argv[0] = \"${argv0:-${executable}}\";"
docs="${docs:+$docs$'\n'}execv(\"${executable}\", argv);"
docs="----------"$'\n'"This binary wrapper (created from generated C-code) is configured with the following settings:${docs:+$'\n'$docs}"
escape_string_literal "$docs"
docs=$result
printf "\n%s\n" "const char* DOCS = \"$docs\";"
