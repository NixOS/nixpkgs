{
  stdenv,
  lib,
  fetchFromGitLab,
  buildMozillaMach,
  nixosTests,
}:

(
  (buildMozillaMach rec {
    pname = "firedragon";
    packageVersion = "11.19.1";
    applicationName = "FireDragon";
    binaryName = "firedragon";
    branding = "browser/branding/official";
    requireSigning = false;
    allowAddonSideload = true;

    # Must match the contents of `browser/config/version.txt` in the source tree
    version = "128.4.0";

    src = fetchFromGitLab {
      owner = "garuda-linux";
      repo = "firedragon";
      fetchSubmodules = true;
      rev = "v${packageVersion}";
      hash = "";
    };

    extraConfigureFlags = [
      "--with-app-name=${pname}"
      "--with-app-basename=${applicationName}"
      "--with-unsigned-addon-scopes=app,system"
      "--enable-proxy-bypass-protection"
    ];

    meta = {
      description = "FireDragon is a browser based on the excellent Floorp browser";
      homepage = "https://firedragon.garudalinux.org/";
      maintainers = with lib.maintainers; [ liberodark ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit;
      # since Firefox 60, build on 32-bit platforms fails with "out of memory".
      # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
      license = lib.licenses.mpl20;
      mainProgram = "firedragon";
    };
    tests = {
      inherit (nixosTests) firedragon;
    };
  }).override
  {
    # Upstream build configuration can be found at
    # .github/workflows/src/linux/shared/mozconfig_linux_base
    privacySupport = true;
    webrtcSupport = true;
    enableOfficialBranding = false;
    googleAPISupport = true;
    mlsAPISupport = true;
  }
).overrideAttrs
  (prev: {
    MOZ_DATA_REPORTING = "";
    MOZ_TELEMETRY_REPORTING = "";

    # Upstream already includes some of the bugfix patches that are applied by
    # `buildMozillaMach`. Pick out only the relevant ones for Floorp and override
    # the list here.
    patches = [
      ../firefox/env_var_for_system_dir-ff111.patch
      ../firefox/no-buildconfig-ffx121.patch
    ];
  })
