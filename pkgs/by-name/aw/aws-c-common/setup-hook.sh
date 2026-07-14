addAwsCCommonModuleDir() {
    prependToVar cmakeFlags "-DCMAKE_MODULE_PATH=@out@/lib/cmake"
}

postHooks+=(addAwsCCommonModuleDir)
