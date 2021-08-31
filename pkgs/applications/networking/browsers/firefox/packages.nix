{ stdenv, lib, callPackage, fetchurl, fetchFromGitLab, fetchpatch, nixosTests }:

let
  common = opts: callPackage (import ./common.nix opts) {};
in

rec {
  firefox = common rec {
    pname = "firefox";
    version = "92.0";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "1a73cc275ea1790120845f579a7d21713ea78db0867ced767f393dfc25b132292dfbb673290fccdb9dcde86684e0300d56565841985fa3f0115376c91154ba8e";
    };

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco lovesegfault hexa ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
      license = lib.licenses.mpl20;
    };
    tests = [ nixosTests.firefox ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
    };
  };

  firefox-esr-91 = common rec {
    pname = "firefox-esr";
    version = "91.1.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "dad0249eb2ce66eb90ff5daf0dfb63105a19790dd45661d977f7cc889644e86b33b9b0c472f46d4032ae2e4fe02c2cf69d552156fb0ad4cf77a15b3542556ed3";
    };

    meta = {
      description = "A web browser built from Firefox Extended Support Release source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ hexa ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    tests = [ nixosTests.firefox-esr-91 ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-91-unwrapped";
      versionSuffix = "esr";
    };
  };

  firefox-esr-78 = common rec {
    pname = "firefox-esr";
    version = "78.14.0esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "5d5e4b1197f87b458a8ab14a62701fa0f3071e9facbb4fba71a64ef69abf31edbb4c5efa6c20198de573216543b5289270b5929c6e917f01bb165ce8c139c1ac";
    };

    meta = {
      description = "A web browser built from Firefox Extended Support Release source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco hexa ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    tests = [ nixosTests.firefox-esr-78 ];
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-78-unwrapped";
      versionSuffix = "esr";
    };
  };

  librewolf = let
    inherit (builtins) attrNames filter readDir;
    inherit (lib) hasSuffix;
    lwRelease = "1";
    lwPatchesTag = "v${firefox.version}-${lwRelease}";
    lwSettingsTag = "1.6";
    lwPatches = fetchFromGitLab {
      group = "librewolf-community";
      owner = "browser";
      repo = "common";
      rev = lwPatchesTag;
      sha256 = "Uzm3wYewVyFOKHnXAw28bOuCHTR/kiHQvQpLG7a1Xhw=";
    };
    lwSettings = fetchFromGitLab {
      owner = "librewolf-community";
      repo = "settings";
      rev = lwSettingsTag;
      sha256 = "lG8OmDUkkaG9imCj6H/aqEVCca8AG4PW3A9LKQ2x3b8=";
    };
  in common rec {
    pname = "librewolf";
    version = firefox.version;
    src = firefox.src;

    # TODO: Maybe force override this in extraConfigureFlags and
    #       extraMakeFlags instead of modifying `common.nix`.
    allowOfficialBranding = false;
    binaryName = "librewolf";

    # Adapted from
    # https://gitlab.com/librewolf-community/browser/arch/-/blob/master/PKGBUILD#L48
    # for now; except for --disable-updater and --enable-release.
    #
    # None of these are set by the `common` function, but most of
    # these are integral to what librewolf does (disable telemetry and
    # pre-installed addons ala pocket, as well as the actual
    # branding).
    #
    # It'd be nice if this were more centralized, see
    # https://gitlab.com/librewolf-community/browser/common/-/issues/37
    extraConfigureFlags = [
      "--enable-hardening"
      "--enable-rust-simd"
      "--enable-update-channel=release"
      "--with-app-name=librewolf"
      "--with-app-basename=LibreWolf"
      "--with-branding=browser/branding/librewolf"
      "--with-distribution-id=io.gitlab.librewolf-community"
      "--with-unsigned-addon-scopes=app,system"
      "--allow-addon-sideload"
      "--disable-crashreporter"
    ];
    extraMakeFlags = [
      "MOZ_REQUIRE_SIGNING=0"
      "MOZ_CRASHREPORTER=0"
      "MOZ_DATA_REPORTING=0"
      "MOZ_SERVICES_HEALTHREPORT=0"
      "MOZ_TELEMETRY_REPORTING=0"
    ];

    postUnpack = ''
      cp -r ${lwPatches}/source_files/browser "$sourceRoot"
      chmod -R u+w "$sourceRoot/browser"
    '';

    patches = let
      readSubdir = subdir:
        filter (hasSuffix ".patch")
        (map (path: "${lwPatches}/${subdir}/${path}")
          (attrNames (readDir "${lwPatches}/${subdir}")));
    in (readSubdir "patches") ++ (readSubdir "patches/sed-patches") ++ [
      # An additional patch to fix a wayland compilation issue
      # that librewolf tickles out
      (fetchpatch {
        name = "fix-wayland-build.patch";
        sha256 = "sha256-LcWx1PvUHvGf6ArNIYkAd2ucbqFbf7pw+VKATjok8wo=";
        url =
          "https://aur.archlinux.org/cgit/aur.git/plain/fix-wayland-build.patch?h=c6dd893ec36daa57e80759ed364b55c51c1ea5ea";
      })
    ];

    extraLib = lwSettings;

    meta = {
      description =
        "A fork of Firefox, focused on privacy, security and freedom.";
      homepage = "https://librewolf-community.gitlab.io/";
      # maintainers = with lib.maintainers; [ tlater ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit;
      license = lib.licenses.mpl20;
    };
  };
}
