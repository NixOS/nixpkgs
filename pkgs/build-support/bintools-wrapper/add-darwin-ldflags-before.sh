# Unconditionally adding in platform version flags will result in warnings that
# will be treated as errors by some packages. Add any missing flags here.

# There are two things to be configured: the "platform version" (oldest
# supported version of macos, ios, etc), and the "sdk version".
#
# The modern way of configuring these is to use:
#    -platform_version $platform $platform_version $sdk_version"
#
# The old way is still supported, and uses flags like:
#    -${platform}_version_min $platform_version
#    -sdk_version $sdk_version
#
# If both styles are specified ld will combine them. If multiple versions are
# specified for the same platform, ld will emit an error.
#
# The following adds flags for whichever properties have not already been
# provided.

havePlatformVersionFlag=
haveDarwinSDKVersion=
haveDarwinPlatformVersion=

# Roles will set by add-flags.sh, but add-flags.sh can be skipped when the
# cc-wrapper has added the linker flags. Both the cc-wrapper and the binutils
# wrapper mangle the same variable (MACOSX_DEPLOYMENT_TARGET), so if roles are
# empty due to being run through the cc-wrapper then the mangle here is a no-op
# and we still do the right thing.
#
# To be robust, make sure we always have the correct set of roles.
accumulateRoles

mangleVarSingle @darwinMinVersionVariable@ ${role_suffixes[@]+"${role_suffixes[@]}"}

n=0
nParams=${#params[@]}
while (( n < nParams )); do
    p=${params[n]}
    case "$p" in
        # the current platform
        -@darwinPlatform@_version_min)
            haveDarwinPlatformVersion=1
            ;;

        # legacy aliases
        -macosx_version_min|-iphoneos_version_min|-iosmac_version_min|-uikitformac_version_min)
            haveDarwinPlatformVersion=1
            ;;

        -sdk_version)
            haveDarwinSDKVersion=1
            ;;

        -platform_version)
            havePlatformVersionFlag=1

            # If clang can't determine the sdk version it will pass 0.0.0. This
            # has runtime effects so we override this to use the known sdk
            # version.
            if [ "${params[n+3]-}" = 0.0.0 ]; then
                params[n+3]=@darwinSdkVersion@
            fi
            ;;
    esac
    n=$((n + 1))
done

# If the caller has set -platform_version, trust they're doing the right thing.
# This will be the typical case for clang in nixpkgs.
if [ ! "$havePlatformVersionFlag" ]; then
    if [ ! "$haveDarwinSDKVersion" ] && [ ! "$haveDarwinPlatformVersion" ]; then
        # Nothing provided. Use the modern "-platform_version" to set both.
        extraBefore+=(-platform_version @darwinPlatform@ "${@darwinMinVersionVariable@_@suffixSalt@:-@darwinMinVersion@}" @darwinSdkVersion@)
    elif [ ! "$haveDarwinSDKVersion" ]; then
        # Add missing sdk version
        extraBefore+=(-sdk_version @darwinSdkVersion@)
    elif [ ! "$haveDarwinPlatformVersion" ]; then
        # Add missing platform version
        extraBefore+=(-@darwinPlatform@_version_min "${@darwinMinVersionVariable@_@suffixSalt@:-@darwinMinVersion@}")
    fi
fi
