{ lib }:

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

  # Returns true if the target is no_std
  # https://github.com/rust-lang/rust/blob/2e44c17c12cec45b6a682b1e53a04ac5b5fcc9d2/src/bootstrap/config.rs#L415-L421
  IsNoStdTarget = platform: let rustTarget = toRustTarget platform; in
    builtins.any (t: lib.hasInfix t rustTarget) ["-none" "nvptx" "switch" "-uefi"];
}
