addEmscriptenCMakeEnv () {
    cmakeFlagsArray+=(
        "-DCMAKE_TOOLCHAIN_FILE=@emscripten@/share/emscripten/cmake/Modules/Platform/Emscripten.cmake"
    )
}

addEnvHooks "$hostOffset" addEmscriptenCMakeEnv
