{
  stdenv,
  lib,
  buildMozillaMach,
  callPackage,
  fetchurl,
  fetchpatch,
  nixosTests,
  icu,
  fetchpatch2,
  config,
}:

let
  common =
    {
      version,
      sha512,
      updateScript,
    }:
    (buildMozillaMach rec {
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
        description = "A full-featured e-mail client";
        homepage = "https://thunderbird.net/";
        mainProgram = "thunderbird";
        maintainers = with maintainers; [
          eelco
          lovesegfault
          pierron
          vcunat
        ];
        platforms = platforms.unix;
        badPlatforms = platforms.darwin;
        broken = stdenv.buildPlatform.is32bit;
        # since Firefox 60, build on 32-bit platforms fails with "out of memory".
        # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
        license = licenses.mpl20;
        knownVulnerabilities = lib.optionals (lib.versionOlder version "116") [
          "Thunderbird 115 support ended in Octoboer 2024."
        ];
      };
    }).override
      {
        geolocationSupport = false;
        webrtcSupport = false;

        pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"

        icu = icu.overrideAttrs (attrs: {
          # standardize vtzone output
          # Work around ICU-22132 https://unicode-org.atlassian.net/browse/ICU-22132
          # https://bugzilla.mozilla.org/show_bug.cgi?id=1790071
          patches = attrs.patches ++ [
            (fetchpatch2 {
              url = "https://hg.mozilla.org/mozilla-central/raw-file/fb8582f80c558000436922fb37572adcd4efeafc/intl/icu-patches/bug-1790071-ICU-22132-standardize-vtzone-output.diff";
              stripLen = 3;
              hash = "sha256-MGNnWix+kDNtLuACrrONDNcFxzjlUcLhesxwVZFzPAM=";
            })
          ];
        });
      };

in
rec {
  thunderbird = thunderbird-128;

  thunderbird-115 = common {
    version = "115.16.0esr";
    sha512 = "1c70050a773c92593dca2a34b25e9e6edcef6fbb9b081024e4dba024450219e06aace52d9fb90ccc2e8069b7bba0396258c86cc19848a7ac705b42641f6e36a5";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-115";
      versionPrefix = "115";
      versionSuffix = "esr";
    };
  };

  thunderbird-128 = common {
    version = "128.5.1esr";
    sha512 = "1dfa0752a1dbfc4d7516beab13e188aa40c145f2eb0554441ecc4dff739cc862c15fdfdd8c0cc026d010ba3caa57d6168da35e484c04989fb6c81f5c09215831";

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
