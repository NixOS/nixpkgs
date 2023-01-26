#!/usr/bin/env bash
set -euo pipefail

# https://stackoverflow.com/a/246128
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
script_name=$(basename ${BASH_SOURCE[0]})

nixpkgs_root=$(realpath "$script_dir"/../../..)
lib_path=${LIB_PATH:-$(realpath "$nixpkgs_root/lib")}
property_to_test=${1:-}
original_seed=${2:-$RANDOM}
seed=$original_seed


tmp=$(mktemp -d)
trap 'rm -r "$tmp"' exit

stage_setup() {
    #echo "stage_setup $*"
    count=$1

    steps_file="$tmp"/steps/"$property"
    case_dir="$tmp"/cases/"$property"
    if [[ -e "$case_dir" ]]; then
        # Cleaning up any previous case
        rm -r "$case_dir"
    fi
    mkdir -p "$(dirname "$steps_file")"
    touch "$steps_file"
    eval 'mkdir -p "$case_dir"/{0..'$((count - 1))'}'
}

stage_condition_non_equal() {
    for c in "$case_dir"/*; do
        if ! diff "$c/$1" "$c/$2" >/dev/null; then
            rm -r "$c"
        fi
    done
}

stage_awk_expr() {
    #echo "stage_awk_expr $*"
    declare -a variable_ordering
    declare -A variables
    while [[ "$#" -gt 1 ]]; do
        variable_ordering+=($1)
        variables[$1]=$2
        echo "awk $1 $2" >> "$steps_file"
        shift 2
    done

    echo "function stage() {" > "$tmp/expr.awk"
    for variable in "${variable_ordering[@]}"; do
        echo "    $variable = ${variables[$variable]}" >> "$tmp/expr.awk"
        echo "    write(\"$variable\", $variable)" >> "$tmp/expr.awk"
    done
    echo "}" >> "$tmp/expr.awk"

    # echo "Running awk stage $1"
    awk -f "$tmp/expr.awk" \
        -f "$script_dir"/stage/awk.awk \
        -v seed="$seed" \
        -v count="$count" \
        -v case_dir="$case_dir"


    # Increase the seed such that each stage gets a different (but deterministic) seed
    ((seed++)) || true
}

stage_nix_expr() {
    #echo "stage_nix_expr $*"
    local variable=$1
    local expr=$2
    printf "%s" "$expr" > "$tmp/expr.nix"
    nix-instantiate "$script_dir"/stage/nix-eval.nix \
        --argstr libPath "$lib_path" \
        --argstr caseDir "$case_dir" \
        --argstr variable "$variable" \
        --argstr exprFile "$tmp/expr.nix" \
        --eval --strict --json | jq -r > "$tmp/nix-script"

    source "$tmp/nix-script"

    echo "nix $variable $expr" >> "$steps_file"
}

stage_bash_expr() {
    #echo "stage_bash_expr $*"
    local variable=$1
    local expr=$2

    for c in "$case_dir"/*; do
        (
            cd "$c"
            for f in *; do
                eval "$f=\$(<$f)"
            done
            eval "$expr" > $variable
        )
    done
    echo "bash $variable $expr" >> "$steps_file"
}

stage_constant() {
    #echo "stage_costant $*"
    local variable=$1
    local string=$2

    for c in "$case_dir"/*; do
        printf "%s" "$string" > "$c"/"$variable"
    done
    echo "constant $variable $string" >> "$steps_file"
}

stage_condition() {
    _stage_check "$@" skip
}

stage_check() {
    _stage_check "$@" fail
}

_stage_check() {
    local var1=$1
    local check=$2
    local var2=$3
    local action=$4

    #echo "stage_check $*"
    # echo "Checking that for each test case, files $1 and $2 are the same"
    for c in "$case_dir"/*; do
        left_value=$(<"$c/$var1")
        right_value=$(<"$c/$var2")
        left_pretty="\e[32m$var1\e[0m"
        right_pretty="\e[34m$var2\e[0m"
        case "$check" in
            "==")
                if [[ "$left_value" == "$right_value" ]]; then
                    continue
                elif [[ "$action" == "skip" ]]; then
                    rm -r "$c"
                    continue
                else
                    echo -e "Property test $property failed: Expected variables $left_pretty and $right_pretty to be the same, but they're not"
                fi
                ;;
            "!=")
                if [[ "$left_value" != "$right_value" ]]; then
                    continue
                elif [[ "$action" == "skip" ]]; then
                    rm -r "$c"
                    continue
                else
                    echo -e "Property test $property failed: Expected variables $left_pretty and $right_pretty to be different, but they're not"
                fi
                ;;
            *)
                echo "stage_check: comparison $check not supported"
                exit 1
                ;;
        esac

        while read type variable expr; do
            if [[ "$var1" == "$variable" ]]; then
                variable_text="$left_pretty"
            elif [[ "$var2" == "$variable" ]]; then
                variable_text="$right_pretty"
            else
                variable_text="$variable"
            fi
            echo -e "[$type] $variable_text = $expr =\n  $(<"$c/$variable")"
        done <"$steps_file"
        echo >&2 "To reproduce run: $(realpath --relative-to="$nixpkgs_root" "$script_dir/$script_name") $property $seed"
        exit 1
    done
}



for prop in "$script_dir"/props/*; do
    property="$(basename "${prop%%.*}")"
    if [[ -n "$property_to_test" && "$property" != "$property_to_test" ]]; then
        continue
    fi
    echo >&2 "Running property test $property"
    source "$prop"
done
