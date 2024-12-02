addRepDLLoadPath () {
    addToSearchPath REP_DL_LOAD_PATH $1/lib/rep
}

addEnvHooks "$hostOffset" addRepDLLoadPath
