#!@shell@

compileCythonDebugSpeedupsHook() {
    echo "compiling cython debug speedups" >&2
    if [[ -d plugins/python-ce ]]; then
        @python@ plugins/python-ce/helpers/pydev/setup_cython.py build_ext --inplace
    else
        @python@ plugins/python/helpers/pydev/setup_cython.py build_ext --inplace
    fi
}

preInstallHooks+=(compileCythonDebugSpeedupsHook)
