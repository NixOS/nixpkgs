# Prevent ccWrapper_addCVars from firing
set -u

(( "$hostOffset" < 0 )) || return 0

declare -na hooksVar="${pkgHookVarVars[$targetOffset]}"

for hooks in "${hooksVar[@]}"; do
    declare -na hooks
    for i in "${!hooks[@]}"; do
        if [[ "${hooks[i]}" == "ccWrapper_addCVars" ]]; then
            hooks[i]=true
        fi
        unset i
    done
    unset hook
done

unset hookVar
