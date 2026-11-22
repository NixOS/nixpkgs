rapidsCmakeOfflineHook() {
    appendToVar cmakeFlags \
        "-DFETCHCONTENT_SOURCE_DIR_RAPIDS-CMAKE=@out@/share/rapids-cmake" \
        "-DFETCHCONTENT_FULLY_DISCONNECTED=ON" \
        "-DCPM_DOWNLOAD_LOCATION=@cpm@/share/cpm/CPM.cmake" \
        "-DCPM_USE_LOCAL_PACKAGES=ON"
}
postHooks+=(rapidsCmakeOfflineHook)
