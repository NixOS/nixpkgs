{ stdenv, lib, buildMozillaMach, callPackage, fetchurl, fetchpatch, nixosTests, icu73, fetchpatch2, config }:

let
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

    meta = with lib; {
      changelog = "https://www.thunderbird.net/en-US/thunderbird/${version}/releasenotes/";
      description = "Full-featured e-mail client";
      homepage = "https://thunderbird.net/";
      mainProgram = "thunderbird";
      maintainers = with maintainers; [ lovesegfault pierron vcunat ];
      platforms = platforms.unix;
      badPlatforms = platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = licenses.mpl20;
    };
  }).override {
    geolocationSupport = false;
    webrtcSupport = false;

    pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"

    icu73 = icu73.overrideAttrs (attrs: {
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

in rec {
  thunderbird = thunderbird-128;

  thunderbird-115 = common {
    version = "115.14.0";
    sha512 = "b12e1302d6be94dd88bee6dd069d3fec944bfce95e1afc1d72c14cc188d952fd5a85f0e70575317250701ac89498d876f3384b022957689fabcef61ad7d78c29";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-115";
      versionPrefix = "115";
    };
  };

  thunderbird-128 = common {
    version = "128.1.0esr";
    sha512 = "cda64afee45ae20a627116f9475cc4421262db40a7efa09eeafcb6e96f8fad97e8c96e2ecf04466ac4bce99fcebe0c3ce9953fa3fc4f5a92ab6f60e122f58c9a";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-128";
      versionPrefix = "128";
      versionSuffix = "esr";
    };
  };
}
 // lib.optionalAttrs config.allowAliases {
  thunderbird-102 = throw "Thunderbird 102 support ended in September 2023";
}

