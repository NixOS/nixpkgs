# shellcheck disable=SC2154,SC2034,SC2016

addHarepath() {
    local -r thirdparty="${1-}/src/hare/third-party"
    if [[ -d "$thirdparty" ]]; then
        addToSearchPath HAREPATH "$thirdparty"
    fi
}

# Hare's stdlib should come after its third party libs, since the latter may
# expand or shadow the former.
readonly hareSetStdlibPhase='
addToSearchPath HAREPATH "@hare_stdlib@"
'
readonly hareInfoPhase='
echoCmd "HARECACHE" "$HARECACHE"
echoCmd "HAREPATH" "$HAREPATH"
echoCmd "hare" "$(command -v hare)"
echoCmd "hare-native" "$(command -v hare-native)"
'
appendToVar prePhases hareSetStdlibPhase hareInfoPhase

readonly hare_unconditional_flags="@hare_unconditional_flags@"
case "${hareBuildType:-"release"}" in
"release") export NIX_HAREFLAGS="-R $hare_unconditional_flags" ;;
"debug") export NIX_HAREFLAGS="$hare_unconditional_flags" ;;
*)
    printf -- 'Invalid hareBuildType: "%s"\n' "${hareBuildType-}"
    exit 1
    ;;
esac

HARECACHE="$(mktemp -d)"
export HARECACHE

addEnvHooks "$hostOffset" addHarepath
