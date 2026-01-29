{
  stdenv,
  lib,
  buildMozillaMach,
  callPackage,
  fetchurl,
  fetchpatch2,
  config,
}:

let
  common =
    {
      version,
      sha512,
      updateScript,
      applicationName ? "Thunderbird",
    }:
    (buildMozillaMach rec {
      pname = "thunderbird";
      inherit version updateScript applicationName;
      application = "comm/mail";
      binaryName = "thunderbird";
      src = fetchurl {
        url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
        inherit sha512;
      };
      extraPatches = [
        # The file to be patched is different from firefox's `no-buildconfig-ffx90.patch`.
        (if lib.versionOlder version "140" then ./no-buildconfig.patch else ./no-buildconfig-tb140.patch)
      ];

      meta = {
        changelog = "https://www.thunderbird.net/en-US/thunderbird/${version}/releasenotes/";
        description = "Full-featured e-mail client";
        homepage = "https://thunderbird.net/";
        mainProgram = "thunderbird";
        maintainers = with lib.maintainers; [
          booxter # darwin
          lovesegfault
          pierron
          vcunat
        ];
        platforms = lib.platforms.unix;
        broken = stdenv.buildPlatform.is32bit;
        # since Firefox 60, build on 32-bit platforms fails with "out of memory".
        # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
        license = lib.licenses.mpl20;
      };
    }).override
      {
        geolocationSupport = false;
        webrtcSupport = false;

        pgoSupport = false; # console.warn: feeds: "downloadFeed: network connection unavailable"
      };

in
rec {
  thunderbird = thunderbird-latest;

  thunderbird-latest = common {
    version = "146.0.1";
    sha512 = "8a3b2de246c7c597574fce596836c7ef7b24bd21573feb15c308003f34b82335ad865aa0f81b24d1669c8023c0448c0e273a63019aab13356b023c2e8adc2c47";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-latest";
    };
  };

  # Eventually, switch to an updateScript without versionPrefix hardcoded...
  thunderbird-esr = thunderbird-140;

  thunderbird-140 = common {
    applicationName = "Thunderbird ESR";

    version = "140.7.0esr";
    sha512 = "92746d87ca2d5a59082c25aa3c3a816e5bf24ae3e095f8ec478a60c5cd890faea392ff98b5b510cc9a89b155240dce9d06c7ddd0f17f564722acc65105fb6cd2";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-140";
      versionPrefix = "140";
      versionSuffix = "esr";
    };
  };
}
// lib.optionalAttrs config.allowAliases {
  thunderbird-102 = throw "Thunderbird 102 support ended in September 2023";
  thunderbird-115 = throw "Thunderbird 115 support ended in October 2024";
  thunderbird-128 = throw "Thunderbird 128 support ended in August 2025";
}
