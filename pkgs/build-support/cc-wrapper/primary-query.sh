# Both observations and execution use the raw executable's native frame. The
# caller array remains raw through hooks; only the native driver expands it.
wrapperWriteNativeFrame() {
    local arg
    printf '%s\0' nix-primary-v3 "$primaryPurity" "$wrapper_NIX_ENFORCE_NO_NATIVE" \
        "$primarySDK" "$primaryTarget" \
        "${#primaryBefore[@]}" "${#params[@]}" "${#primaryAfter[@]}" \
        "${#primaryCPP[@]}" "${#primaryMachine[@]}" "${#primaryPrefixes[@]}"
    for arg in "${primaryBefore[@]}" "${params[@]}" "${primaryAfter[@]}" \
        "${primaryCPP[@]}" "${primaryMachine[@]}" "${primaryPrefixes[@]}"; do
        printf '%s\0' "$arg"
    done
}

wrapperNativePolicy() {
    local arg
    primaryPurity=0 primarySDK= primaryTarget=
    primaryPrefixes=() primaryMachine=()
    if [[ ${NIX_ENFORCE_PURITY:-} == 1 && -n ${NIX_STORE:-} ]]; then
        primaryPurity=1
        primaryPrefixes=("$NIX_STORE" "${NIX_BUILD_TOP:-}" /tmp "${TMP:-/tmp}" \
            "${TMPDIR:-/tmp}" "${TEMP:-/tmp}" "${TEMPDIR:-/tmp}")
        if [[ "@darwinMinVersion@" ]]; then primarySDK=${wrapper_SDKROOT:-}; fi
    fi
    if [[ -f @out@/nix-support/native-target ]]; then
        primaryTarget=$(< @out@/nix-support/native-target)
        while IFS= read -r -d '' arg; do primaryMachine+=("$arg"); done \
            < @out@/nix-support/native-machine-flags
    fi
}

wrapperQueryPrimary() {
    local -a primaryBefore=($wrapper_NIX_CFLAGS_COMPILE_BEFORE)
    local -a primaryAfter=($wrapper_CC_CRT_FLAGS $wrapper_NIX_CFLAGS_COMPILE)
    local -a primaryCPP=($wrapper_NIX_CXXSTDLIB_COMPILE)
    local directory cleanup inputFD outputFD status=0 key value
    local -a record=()
    local -A fields=()
    directory=$(@mktemp@ -d "${TMPDIR:-/tmp}/cc-primary.XXXXXXXX")
    printf -v cleanup '@rm@ -rf -- %q; trap - EXIT RETURN' "$directory"
    trap "$cleanup" EXIT RETURN
    wrapperWriteNativeFrame > "$directory/request"
    exec {inputFD}< "$directory/request"
    exec {outputFD}> "$directory/result"
    NIX_CC_PRIMARY_ARGS_FD=$inputFD NIX_CC_PRIMARY_QUERY_FD=$outputFD \
        NIX_CC_PRIMARY_TMPDIR=$directory PATH=$path_backup "$wrapperCompiler" \
        > /dev/null 2> "$directory/stderr" || status=$?
    exec {inputFD}<&-
    exec {outputFD}>&-
    if ((status)); then @cat@ "$directory/stderr" >&2; return "$status"; fi
    while IFS= read -r -d '' value; do record+=("$value"); done < "$directory/result"
    [[ -z $value && ${#record[@]} == 2 && ${record[0]} == nix-primary-v3 ]] || return 1
    while IFS='=' read -r key value; do
        case "$key" in
            version) [[ $value == 3 ]] || return 1 ;;
            entry) [[ $value == driver || $value == frontend ]] || return 1 ;;
            requested_host_link|c_include|cxx_include|cxx_personality|cxx_library)
                [[ $value == 0 || $value == 1 ]] || return 1 ;;
            *) return 1 ;;
        esac
        [[ ! -v fields[$key] ]] || return 1
        fields[$key]=$value
    done < <(printf %s "${record[1]}")
    ((${#fields[@]} == 7)) || return 1
    dontLink=$((1 - ${fields[requested_host_link]}))
    cInclude=${fields[c_include]}; cxxInclude=${fields[cxx_include]}
    cxxLibrary=${fields[cxx_library]}; isCxx=${fields[cxx_personality]}
    cc1=0; [[ ${fields[entry]} != frontend ]] || cc1=1
    @rm@ -rf -- "$directory"
    trap - EXIT RETURN
}

wrapperExecuteNative() {
    local -a primaryBefore=("${extraBefore[@]}") primaryAfter=("${extraAfter[@]}") primaryCPP=()
    local directory cleanup inputFD
    directory=$(@mktemp@ -d "${TMPDIR:-/tmp}/cc-execution.XXXXXXXX")
    printf -v cleanup '@rm@ -rf -- %q; trap - EXIT RETURN' "$directory"
    trap "$cleanup" EXIT RETURN
    wrapperWriteNativeFrame > "$directory/request"
    exec {inputFD}< "$directory/request"
    @rm@ -rf -- "$directory"
    trap - EXIT RETURN
    unset NIX_CC_PRIMARY_QUERY_FD NIX_CC_PRIMARY_TMPDIR
    NIX_CC_PRIMARY_ARGS_FD=$inputFD wrapperRun "$wrapperOperation" "$wrapperCompiler"
}
