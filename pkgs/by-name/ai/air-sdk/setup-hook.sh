preConfigureHooks+=(setupAirSdkEnv)
setupAirSdkEnv() {
    export AIR_HOME="@out@/share/AIRSDK"
}
