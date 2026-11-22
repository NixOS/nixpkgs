
fixupCFlagsForDarwin() {
    # Because it’s getting called from a Darwin stdenv, MinGW will pick up on Darwin-specific
    # flags, and the ./configure tests will fail to consider it a working cross-compiler.
    # Strip them out, so Wine can use MinGW to build its DLLs instead of trying to use Clang.
    # Ideally, it would be possible to build the DLLs on Windows (i.e., as part of `pkgsCross``),
    # but that is not the case currently with Wine’s build system.
    cflagsFilter='s|-F[^ ]*||g;s|-iframework [^ ]*||g;s|-isystem [^ ]*||g;s|  *| |g'

    # libiconv and libintl aren’t needed by Wine, and having them causes linking to fail.
    # The `CoreFoundation` reference is added by `linkSystemCoreFoundationFramework` in the
    # Apple SDK’s setup hook. Remove that because MingW will fail due to file not found.
    ldFlagsFilter='s|-lintl||g;s|-liconv||g;s|/nix/store/[^-]*-apple-framework-CoreFoundation[^ ]*||g'

    # `cc-wrapper.sh`` supports getting flags from a system-specific salt. While it is currently a
    # tuple, that’s not considered a stable interface, so the Wine derivation will provide them:
    # - for Darwin: The source is `stdenv.cc.suffixSalt`; and
    # - for MinGW: The source is the `suffixSalt`` attribute of each of the `mingwGccs`.
    export NIX_CFLAGS_COMPILE_@darwinSuffixSalt@=${NIX_CFLAGS_COMPILE-}
    export NIX_LDFLAGS_@darwinSuffixSalt@=${NIX_LDFLAGS-}
    for mingwSalt in @mingwGccsSuffixSalts@; do
        echo removing @darwinSuffixSalt@-specific flags from NIX_CFLAGS_COMPILE for $mingwSalt
        export NIX_CFLAGS_COMPILE_$mingwSalt+="$(sed "$cflagsFilter" <<< "$NIX_CFLAGS_COMPILE")"
        echo removing @darwinSuffixSalt@-specific flags from NIX_LDFLAGS for $mingwSalt
        export NIX_LDFLAGS_$mingwSalt+="$(sed "$ldFlagsFilter;$cflagsFilter" <<< "$NIX_LDFLAGS")"
    done

    # Make sure the global flags aren’t accidentally influencing the platform-specific flags.
    export NIX_CFLAGS_COMPILE=""
    export NIX_LDFLAGS=""
}

# This is pretty hacky, but this hook _must_ run after `linkSystemCoreFoundationFramework`.
function runFixupCFlagsForDarwinLast() {
    preConfigureHooks+=(fixupCFlagsForDarwin)
}
postUnpackHooks+=(runFixupCFlagsForDarwinLast)
