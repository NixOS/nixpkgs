{
  pkgs,
  stdenv,
  fetchpatch2,
  writeTextFile,
  lib,
}:

# There have been issues with proofs failing on NixOS in the past,
# so we pin polyml to the exact commit that upstream isabelle uses
# For the current release, this is 5.9.2, same as nixpkgs
pkgs.polyml.overrideAttrs (
  finalAttrs: prevAttrs: {
    # Derived from https://github.com/polyml/polyml/compare/v5.9.2...fixes-5.9.2
    patches = [
      # Fix an extra problem with right shifting negative numbers
      (fetchpatch2 {
        url = "https://github.com/polyml/polyml/commit/64eb08b0a4bcb20d39167550034f30d05a61f121.patch?full_index=1";
        hash = "sha256-Xn7Mud67DXikSwSgezXLAt95QeotXrURdY4N+aF/2m4=";
      })
    ];

    configureFlags = lib.remove "--enable-shared" prevAttrs.configureFlags ++ [
      "--enable-intinf-as-int"
      "--disable-shared"
    ];

    passthru.settings = writeTextFile {
      name = "polyml-settings";
      text = ''
        ML_SYSTEM_64=${lib.boolToString stdenv.hostPlatform.is64bit}
        ML_SYSTEM=${finalAttrs.finalPackage.name}
        ML_PLATFORM=${stdenv.hostPlatform.system}
        ML_OPTIONS="--minheap 1000"
        POLYML_HOME=${finalAttrs.finalPackage}
      '';
      destination = "/etc/settings";
    };
  }
)
