{
  stdenv,
  lib,
  callPackage,
  buildMozillaMach,
  nixosTests,
}:

let
  librewolf-src = callPackage ./librewolf.nix { };
in
(buildMozillaMach rec {
  pname = "librewolf";
  applicationName = "LibreWolf";
  binaryName = "librewolf";
  version = librewolf-src.packageVersion;
  src = librewolf-src.firefox;
  requireSigning = false;
  allowAddonSideload = true;
  branding = "browser/branding/librewolf";
  inherit (librewolf-src)
    extraConfigureFlags
    extraPatches
    extraPostPatch
    extraPassthru
    ;

  meta = {
    description = "Fork of Firefox, focused on privacy, security and freedom";
    homepage = "https://librewolf.net/";
    maintainers = with lib.maintainers; [
      squalus
      dwrege
    ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
    broken = stdenv.buildPlatform.is32bit;
    # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
    mainProgram = "librewolf";
  };
  tests = { inherit (nixosTests) librewolf; };
  updateScript = callPackage ./update.nix {
    attrPath = "librewolf-unwrapped";
  };
}).override
  {
    crashreporterSupport = false;
    enableOfficialBranding = false;
  }
