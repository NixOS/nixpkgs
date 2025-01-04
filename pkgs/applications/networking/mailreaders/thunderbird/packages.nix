{ stdenv, lib, buildMozillaMach, callPackage, fetchurl, icu73, fetchpatch2, config }:

let
  icu73' = icu73.overrideAttrs (attrs: {
    # standardize vtzone output
    # Work around ICU-22132 https://unicode-org.atlassian.net/browse/ICU-22132
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1790071
    patches = attrs.patches ++ [(fetchpatch2 {
      url = "https://hg.mozilla.org/mozilla-central/raw-file/fb8582f80c558000436922fb37572adcd4efeafc/intl/icu-patches/bug-1790071-ICU-22132-standardize-vtzone-output.diff";
      stripLen = 3;
      hash = "sha256-MGNnWix+kDNtLuACrrONDNcFxzjlUcLhesxwVZFzPAM=";
    })];
  });

  common = { version, sha512, updateScript }: (buildMozillaMach rec {
    pname = "thunderbird";
    inherit version updateScript;
    application = "comm/mail";
    applicationName = "Mozilla Thunderbird";
    binaryName = pname;
    src = fetchurl {
      url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
      inherit sha512;
    };
    extraPatches = [
      # The file to be patched is different from firefox's `no-buildconfig-ffx90.patch`.
      ./no-buildconfig.patch
    ];

    extraPassthru = {
      icu73 = icu73';
    };

    meta = with lib; {
      changelog = "https://www.thunderbird.net/en-US/thunderbird/${version}/releasenotes/";
      description = "Full-featured e-mail client";
      homepage = "https://thunderbird.net/";
      mainProgram = "thunderbird";
      maintainers = with maintainers; [ lovesegfault pierron vcunat ];
      platforms = platforms.unix;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = licenses.mpl20;
    };
  }).override {
    geolocationSupport = false;
    webrtcSupport = false;

    pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"

    icu73 = icu73';
  };

in rec {
  # Upstream claims -latest is "for testing purposes only". Stick to -esr until this changes.
  thunderbird = thunderbird-esr;

  thunderbird-latest = common {
    version = "132.0.1";
    sha512 = "ff2ff1344c3ab6594fba2e03d3f0548221934b94972819cfb6de9cea0bf9bac4ec67d14e7c6b9ae854ecdbc472b814a5f6f7204a9ce71ddac6167ff536a6276a";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-latest";
    };
  };

  # Eventually, switch to an updateScript without versionPrefix hardcoded...
  thunderbird-esr = thunderbird-128;

  thunderbird-128 = common {
    version = "128.4.3esr";
    sha512 = "18691722f6376f3dc0658c01164fcdbf6008fc31eff8c1bd403d34f188db0e7850883315a96fc07289d207c9977d732628d3945736aa191fefd0a01735e3037d";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-128";
      versionPrefix = "128";
      versionSuffix = "esr";
    };
  };
}
 // lib.optionalAttrs config.allowAliases {
  thunderbird-102 = throw "Thunderbird 102 support ended in September 2023";
  thunderbird-115 = throw "Thunderbird 115 support ended in October 2024";
}

