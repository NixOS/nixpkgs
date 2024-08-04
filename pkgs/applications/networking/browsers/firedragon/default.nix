{
  buildMozillaMach,
  callPackage,
  fetchFromGitLab,
  fetchurl,
  lib,
  nixosTests,
  pkgs,
  python311,
  stdenv,
}:
let
  current = lib.trivial.importJSON ./version.json;
  packageVersion = current.firedragonSource.version;
  version = current.firefoxVersion;

  settings = fetchFromGitLab {
    owner = "garuda-linux/firedragon";
    repo = "settings";
    fetchSubmodules = false;
    inherit (current.firedragonSettings) rev hash;
  };
in
(
  (buildMozillaMach rec {
    pname = "firedragon";
    applicationName = "FireDragon";
    binaryName = "firedragon";
    branding = "browser/branding/firedragon";
    requireSigning = false;
    allowAddonSideload = true;

    inherit packageVersion version;

    src = fetchurl {
      url = "https://gitlab.com/api/v4/projects/55893651/packages/generic/firedragon/${packageVersion}/firedragon-v${packageVersion}.source.tar.zst";
      inherit (current.firedragonSource) hash;
    };

    updateScript = callPackage ./update.nix { };

    tests = {
      inherit (nixosTests) firedragon;
    };

    extraConfigureFlags = [
      "--disable-debug-js-modules"
      "--disable-debug-symbols"
      "--disable-default-browser-agent"
      "--disable-gpsd"
      "--disable-rust-tests"
      "--disable-warnings-as-errors"
      "--disable-webspeech"
      "--enable-bundled-fonts"
      "--enable-jxl"
      "--enable-private-components"
      "--enable-proxy-bypass-protection"
      "--with-app-name=${pname}"
      "--with-app-basename=${applicationName}"
      "--with-unsigned-addon-scopes=app,system"
    ];

    extraNativeBuildInputs = [ pkgs.zstd ];

    extraPassthru = {
      extraPrefsFiles = [ "${settings}/firedragon.cfg" ];
      extraPoliciesFiles = [ "${settings}/distribution/policies.json" ];
    };

    meta = {
      badPlatforms = lib.platforms.darwin;
      description = "Floorp fork build using custom branding & settings";
      homepage = "https://gitlab.com/garuda-linux/firedragon";
      license = lib.licenses.mpl20;
      maintainers = with lib; [ maintainers.dr460nf1r3 ];
      broken = stdenv.buildPlatform.is32bit;
      # since Firefox 60, build on 32-bit platforms fails with "out of memory".
      # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
      platforms = lib.platforms.unix;
      mainProgram = "firedragon";
    };
  }).override
  {
    crashreporterSupport = false;
    enableOfficialBranding = false;
    pgoSupport = true;
    privacySupport = true;
    python3 = python311;
    webrtcSupport = true;
  }
).overrideAttrs
  {
    MOZ_APP_REMOTINGNAME = "firedragon";
    MOZ_CRASHREPORTER = "";
    MOZ_DATA_REPORTING = "";
    MOZ_SERVICES_HEALTHREPORT = "";
    MOZ_TELEMETRY_REPORTING = "";
    OPT_LEVEL = "3";
    RUSTC_OPT_LEVEL = "3";

    # Upstream already includes some of the bugfix patches that are applied by
    # `buildMozillaMach`. Pick out only the relevant ones for Floorp and override
    # the list here.
    patches = [
      ../firefox/env_var_for_system_dir-ff111.patch
      ../firefox/no-buildconfig-ffx121.patch
    ];
  }
