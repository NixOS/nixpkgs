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
      maintainers = with maintainers; [ eelco lovesegfault pierron vcunat ];
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
  thunderbird = thunderbird-115;

  thunderbird-115 = common {
    version = "115.13.0";
    sha512 = "98ee23f684aa7a166878459a6a217bf3bcc4ddd8fa8ebbd0a1d2d66392ec1ebff67dbad55d145cdd0771539f127d91c4137211cf4efc80e450e6a34c95e8529c";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-115";
      versionPrefix = "115";
    };
  };

  thunderbird-128 = common {
    version = "128.0.1esr";
    sha512 = "db7507fcfd5bc2dd4ad52eaeb87c575d87cb438765861c468ab17678ca6ab32b28b60d0431ec7f558ea0db90fa59e35a8a4aeba046ebd0b00cfb6d9e8019318e";

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

