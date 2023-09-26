{ lib
, stdenv
, buildPackages
, targetPackages
}:

rec {
  # https://doc.rust-lang.org/reference/conditional-compilation.html#target_arch
  toTargetArch = platform:
    /**/ if platform ? rustc.platform then platform.rustc.platform.arch
    else if platform.isAarch32 then "arm"
    else if platform.isMips64  then "mips64"     # never add "el" suffix
    else if platform.isPower64 then "powerpc64"  # never add "le" suffix
    else platform.parsed.cpu.name;

  # https://doc.rust-lang.org/reference/conditional-compilation.html#target_os
  toTargetOs = platform:
    /**/ if platform ? rustc.platform then platform.rustc.platform.os or "none"
    else if platform.isDarwin then "macos"
    else platform.parsed.kernel.name;

  # https://doc.rust-lang.org/reference/conditional-compilation.html#target_family
  toTargetFamily = platform:
    if platform ? rustc.platform.target-family
    then
      (
        # Since https://github.com/rust-lang/rust/pull/84072
        # `target-family` is a list instead of single value.
        let
          f = platform.rustc.platform.target-family;
        in
        if builtins.isList f then f else [ f ]
      )
    else lib.optional platform.isUnix "unix"
      ++ lib.optional platform.isWindows "windows";

  # https://doc.rust-lang.org/reference/conditional-compilation.html#target_vendor
  toTargetVendor = platform: let
    inherit (platform.parsed) vendor;
  in platform.rustc.platform.vendor or {
    "w64" = "pc";
  }.${vendor.name} or vendor.name;

  # Returns the name of the rust target, even if it is custom. Adjustments are
  # because rust has slightly different naming conventions than we do.
  toRustTarget = platform: let
    inherit (platform.parsed) cpu kernel abi;
    cpu_ = platform.rustc.platform.arch or {
      "armv7a" = "armv7";
      "armv7l" = "armv7";
      "armv6l" = "arm";
      "armv5tel" = "armv5te";
      "riscv64" = "riscv64gc";
    }.${cpu.name} or cpu.name;
    vendor_ = toTargetVendor platform;
  in platform.rustc.config
    or "${cpu_}-${vendor_}-${kernel.name}${lib.optionalString (abi.name != "unknown") "-${abi.name}"}";

  # Returns the name of the rust target if it is standard, or the json file
  # containing the custom target spec.
  toRustTargetSpec = platform:
    if platform ? rustc.platform
    then builtins.toFile (toRustTarget platform + ".json") (builtins.toJSON platform.rustc.platform)
    else toRustTarget platform;

  # Returns the name of the rust target if it is standard, or the
  # basename of the file containing the custom target spec, without
  # the .json extension.
  #
  # This is the name used by Cargo for target subdirectories.
  toRustTargetSpecShort = platform:
    lib.removeSuffix ".json"
      (baseNameOf "${toRustTargetSpec platform}");

  # When used as part of an environment variable name, triples are
  # uppercased and have all hyphens replaced by underscores:
  #
  # https://github.com/rust-lang/cargo/pull/9169
  # https://github.com/rust-lang/cargo/issues/8285#issuecomment-634202431
  #
  toRustTargetForUseInEnvVars = platform:
    lib.strings.replaceStrings ["-"] ["_"]
      (lib.strings.toUpper
        (toRustTargetSpecShort platform));

  # Returns true if the target is no_std
  # https://github.com/rust-lang/rust/blob/2e44c17c12cec45b6a682b1e53a04ac5b5fcc9d2/src/bootstrap/config.rs#L415-L421
  IsNoStdTarget = platform: let rustTarget = toRustTarget platform; in
    builtins.any (t: lib.hasInfix t rustTarget) ["-none" "nvptx" "switch" "-uefi"];

  # These environment variables must be set when using `cargo-c` and
  # several other tools which do not deal well with cross
  # compilation.  The symptom of the problem they fix is errors due
  # to buildPlatform CFLAGS being passed to the
  # hostPlatform-targeted compiler -- for example, `-m64` being
  # passed on a build=x86_64/host=aarch64 compilation.
  envVars = let
    ccForBuild = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc";
    cxxForBuild = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}c++";
    ccForHost = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
    cxxForHost = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++";

    # Unfortunately we must use the dangerous `targetPackages` here
    # because hooks are artificially phase-shifted one slot earlier
    # (they go in nativeBuildInputs, so the hostPlatform looks like
    # a targetPlatform to them).
    ccForTarget = "${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc";
    cxxForTarget = "${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}c++";

    rustBuildPlatform = toRustTarget stdenv.buildPlatform;
    rustBuildPlatformSpec = toRustTargetSpec stdenv.buildPlatform;
    rustHostPlatform = toRustTarget stdenv.hostPlatform;
    rustHostPlatformSpec = toRustTargetSpec stdenv.hostPlatform;
    rustTargetPlatform = toRustTarget stdenv.targetPlatform;
    rustTargetPlatformSpec = toRustTargetSpec stdenv.targetPlatform;
  in {
    inherit
      ccForBuild  cxxForBuild  rustBuildPlatform   rustBuildPlatformSpec
      ccForHost   cxxForHost   rustHostPlatform    rustHostPlatformSpec
      ccForTarget cxxForTarget rustTargetPlatform  rustTargetPlatformSpec;

    # Prefix this onto a command invocation in order to set the
    # variables needed by cargo.
    #
    setEnv = ''
    env \
    ''
    # Due to a bug in how splicing and targetPackages works, in
    # situations where targetPackages is irrelevant
    # targetPackages.stdenv.cc is often simply wrong.  We must omit
    # the following lines when rustTargetPlatform collides with
    # rustHostPlatform.
    + lib.optionalString (rustTargetPlatform != rustHostPlatform) ''
      "CC_${toRustTargetForUseInEnvVars stdenv.targetPlatform}=${ccForTarget}" \
      "CXX_${toRustTargetForUseInEnvVars stdenv.targetPlatform}=${cxxForTarget}" \
      "CARGO_TARGET_${toRustTargetForUseInEnvVars stdenv.targetPlatform}_LINKER=${ccForTarget}" \
    '' + ''
      "CC_${toRustTargetForUseInEnvVars stdenv.hostPlatform}=${ccForHost}" \
      "CXX_${toRustTargetForUseInEnvVars stdenv.hostPlatform}=${cxxForHost}" \
      "CARGO_TARGET_${toRustTargetForUseInEnvVars stdenv.hostPlatform}_LINKER=${ccForHost}" \
    '' + ''
      "CC_${toRustTargetForUseInEnvVars stdenv.buildPlatform}=${ccForBuild}" \
      "CXX_${toRustTargetForUseInEnvVars stdenv.buildPlatform}=${cxxForBuild}" \
      "CARGO_TARGET_${toRustTargetForUseInEnvVars stdenv.buildPlatform}_LINKER=${ccForBuild}" \
      "CARGO_BUILD_TARGET=${rustBuildPlatform}" \
      "HOST_CC=${buildPackages.stdenv.cc}/bin/cc" \
      "HOST_CXX=${buildPackages.stdenv.cc}/bin/c++" \
    '';
  };
}
