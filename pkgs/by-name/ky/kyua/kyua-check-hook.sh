kyuaCheckPhase() {
    runHook preCheck
    # Kyua expects to save test results in ~/.kyua/store
    HOME=$TMPDIR kyua test
    runHook postCheck
}

if [ -z "${dontUseKyuaCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=kyuaCheckPhase
fi
