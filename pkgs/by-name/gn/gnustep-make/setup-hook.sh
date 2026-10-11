# this path is used by some packages to install additional makefiles
export DESTDIR_GNUSTEP_MAKEFILES=$out/share/GNUstep/Makefiles

addGnustepInstallFlags() {
    installFlagsArray=( \
      "GNUSTEP_INSTALLATION_DOMAIN=SYSTEM" \
      "GNUSTEP_SYSTEM_APPS=${!outputLib}/lib/GNUstep/Applications" \
      "GNUSTEP_SYSTEM_ADMIN_APPS=${!outputLib}/lib/GNUstep/Applications" \
      "GNUSTEP_SYSTEM_WEB_APPS=${!outputLib}/lib/GNUstep/WebApplications" \
      "GNUSTEP_SYSTEM_TOOLS=${!outputBin}/bin" \
      "GNUSTEP_SYSTEM_ADMIN_TOOLS=${!outputBin}/sbin" \
      "GNUSTEP_SYSTEM_LIBRARY=${!outputLib}/lib/GNUstep" \
      "GNUSTEP_SYSTEM_HEADERS=${!outputInclude}/include" \
      "GNUSTEP_SYSTEM_LIBRARIES=${!outputLib}/lib" \
      "GNUSTEP_SYSTEM_DOC=${!outputDoc}/share/GNUstep/Documentation" \
      "GNUSTEP_SYSTEM_DOC_MAN=${!outputMan}/share/man" \
      "GNUSTEP_SYSTEM_DOC_INFO=${!outputInfo}/share/info" \
    )
}

appendToVar preInstallPhases addGnustepInstallFlags

addGNUstepEnvVars() {
    local filename

    gsAddToSearchPath() {
        if [[ -d "$2" && "${!1-}" != *"$2"* ]]; then
            addToSearchPath "$1" "$2"
        fi
    }

    gsAddToIncludeSearchPath() {
        local -n ref="$1"

        # NOTE: contrary to the one in wrapGNUstepAppsHook, use -e here instead of -d since it's also used for the makefiles
        if [[ -e "$2" && "${ref-}" != *"$2"* ]]; then
            if [[ "${ref-}" != "" ]]; then
                ref+=" "
            fi

            ref+="$2"
        fi
    }

    for filename in $1/share/GNUstep/Makefiles/Additional/*.make ; do
        gsAddToIncludeSearchPath NIX_GNUSTEP_MAKEFILES_ADDITIONAL "$filename"
    done

    export NIX_GNUSTEP_MAKEFILES_ADDITIONAL

    gsAddToSearchPath NIX_GNUSTEP_SYSTEM_APPS "$1/lib/GNUstep/Applications"
    gsAddToSearchPath NIX_GNUSTEP_SYSTEM_ADMIN_APPS "$1/lib/GNUstep/Applications"
    gsAddToSearchPath NIX_GNUSTEP_SYSTEM_WEB_APPS "$1/lib/GNUstep/WebApplications"
    gsAddToSearchPath NIX_GNUSTEP_SYSTEM_TOOLS "$1/bin"
    gsAddToSearchPath NIX_GNUSTEP_SYSTEM_ADMIN_TOOLS "$1/sbin"
    gsAddToSearchPath NIX_GNUSTEP_SYSTEM_LIBRARY "$1/lib/GNUstep"
    gsAddToIncludeSearchPath NIX_GNUSTEP_SYSTEM_HEADERS "$1/include"
    gsAddToSearchPath NIX_GNUSTEP_SYSTEM_LIBRARIES "$1/lib"
    gsAddToSearchPath NIX_GNUSTEP_SYSTEM_DOC "$1/share/GNUstep/Documentation"
    gsAddToSearchPath NIX_GNUSTEP_SYSTEM_DOC_MAN "$1/share/man"
    gsAddToSearchPath NIX_GNUSTEP_SYSTEM_DOC_INFO "$1/share/info"
}
addEnvHooks "$targetOffset" addGNUstepEnvVars

gsmakeSetup() {
    export GNUSTEP_MAKEFILES="$(gnustep-config --variable=GNUSTEP_MAKEFILES)"

    . $GNUSTEP_MAKEFILES/GNUstep.sh
}

preConfigureHooks+=(gsmakeSetup)
