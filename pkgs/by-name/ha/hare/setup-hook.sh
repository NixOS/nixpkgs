# shellcheck disable=SC2016,SC2034,SC2154
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
echoCmd "hareBuildType" "${hareBuildType:-"release"}"
echoCmd "NIX_HAREFLAGS" "$NIX_HAREFLAGS"
echoCmd "hare" "$(command -v hare)"
echoCmd "hare-native" "$(command -v hare-native)"
'
prePhases+=("hareSetStdlibPhase" "hareInfoPhase")

NIX_HAREFLAGS="@hare_unconditional_flags@"
case "${hareBuildType:-"release"}" in
"release") export NIX_HAREFLAGS="$NIX_HAREFLAGS -R" ;;
"debug") export NIX_HAREFLAGS ;;
*)
    printf -- 'Invalid hareBuildType "%s"\n' "${hareBuildType-}" 1>&2
    exit 1
    ;;
esac

HARECACHE="$(mktemp -d)"
export HARECACHE

addEnvHooks "$hostOffset" addHarepath
