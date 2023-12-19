gradleConfigureHook() {
    GRADLE_USER_HOME="$(mktemp -d)"
    export GRADLE_USER_HOME
    gradleFlagsArray+=(--no-daemon --console plain)
    if [ -n "${MITM_CACHE_CA-}" ]; then
        MITM_CACHE_KEYSTORE="$MITM_CACHE_CERT_DIR/keystore"
        MITM_CACHE_KS_PWD="$(head -c10 /dev/random | base32)"
        echo y | @jdk@/bin/keytool -importcert -file "$MITM_CACHE_CA" -alias alias -keystore "$MITM_CACHE_KEYSTORE" -storepass "$MITM_CACHE_KS_PWD"
        gradleFlagsArray+=(-Dhttp.proxyHost="$MITM_CACHE_HOST" -Dhttp.proxyPort="$MITM_CACHE_PORT")
        gradleFlagsArray+=(-Dhttps.proxyHost="$MITM_CACHE_HOST" -Dhttps.proxyPort="$MITM_CACHE_PORT")
        gradleFlagsArray+=(-Djavax.net.ssl.trustStore="$MITM_CACHE_KEYSTORE" -Djavax.net.ssl.trustStorePassword="$MITM_CACHE_KS_PWD")
    else
        gradleFlagsArray+=(--offline)
    fi
}

gradle() {
    command gradle $gradleFlags "${gradleFlagsArray[@]}" "$@"
}

gradleBuildPhase() {
    runHook preBuild

    gradle ${enableParallelBuilding:+--parallel} "${gradleBuildTask:-assemble}"

    runHook postBuild
}

gradleCheckPhase() {
    runHook preCheck

    gradle ${enableParallelChecking:+--parallel} "${gradleCheckTask:-test}"

    runHook postCheck
}

if [ -z "${dontUseGradleConfigure-}" ]; then
    preConfigureHooks+=(gradleConfigureHook)
fi

if [ -z "${dontUseGradleBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=gradleBuildPhase
fi

if [ -z "${dontUseGradleCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=gradleCheckPhase
fi
