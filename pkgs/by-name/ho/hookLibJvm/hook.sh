# shellcheck shell=bash

postInstallHooks+=(libJvm)

libJvm() {
    if [ "${dontLibJvm-}" = 1 ]; then return; fi

    if [ ! -d "${!outputBin:?}" ]; then return; fi

    base="/lib/jvm"
    mkdir -p "${!outputBin:?}${base}"
    ln -fs "${!outputBin:?}" "${!outputBin:?}${base}/${name}"
}
