{ stdenv, lib, buildMozillaMach, callPackage, fetchurl, fetchpatch, nixosTests, icu, fetchpatch2, config }:

rec {
  thunderbird = thunderbird-115;

  thunderbird-115 = (buildMozillaMach rec {
    pname = "thunderbird";
    version = "115.12.0";
    application = "comm/mail";
    applicationName = "Mozilla Thunderbird";
    binaryName = pname;
    src = fetchurl {
      url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
      sha512 = "d262ec2cea3fd003e66974b0bd8d61fb268ad2a233e54a6aea4803c5520e235ea308267f0484581ce235063c4fb90e621cdc1eea3f62212574b90427ede1c289";
    };
    extraPatches = [
      # The file to be patched is different from firefox's `no-buildconfig-ffx90.patch`.
      ./no-buildconfig-115.patch
    ];

    meta = with lib; {
      changelog = "https://www.thunderbird.net/en-US/thunderbird/${version}/releasenotes/";
      description = "Full-featured e-mail client";
      homepage = "https://thunderbird.net/";
      mainProgram = "thunderbird";
      maintainers = with maintainers; [ eelco lovesegfault pierron vcunat ];
      platforms = platforms.unix;
      badPlatforms = platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = licenses.mpl20;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "thunderbird-unwrapped";
      versionPrefix = "115";
    };
  }).override {
    geolocationSupport = false;
    webrtcSupport = false;

    pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"

    icu = icu.overrideAttrs (attrs: {
      # standardize vtzone output
      # Work around ICU-22132 https://unicode-org.atlassian.net/browse/ICU-22132
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1790071
      patches = attrs.patches ++ [(fetchpatch2 {
        url = "https://hg.mozilla.org/mozilla-central/raw-file/fb8582f80c558000436922fb37572adcd4efeafc/intl/icu-patches/bug-1790071-ICU-22132-standardize-vtzone-output.diff";
        stripLen = 3;
        hash = "sha256-MGNnWix+kDNtLuACrrONDNcFxzjlUcLhesxwVZFzPAM=";
      })];
    });
  };
}
 // lib.optionalAttrs config.allowAliases {
  thunderbird-102 = throw "Thunderbird 102 support ended in September 2023";
}

