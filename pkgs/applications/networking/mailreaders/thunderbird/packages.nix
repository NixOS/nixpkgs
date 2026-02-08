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
      # FIXME: let's hope that upstream will fix this soon and we can drop this hack again.
      # https://bugzilla.mozilla.org/show_bug.cgi?id=2006630
      extraPostPatch = lib.optionalString (lib.versionAtLeast version "147") ''
        find . -name .cargo-checksum.json | xargs sed 's/"[^"]*\.gitmodules":"[a-z0-9]*",//g' -i
      '';

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
    version = "147.0.1";
    sha512 = "bae9adbcb1d45a7644e4d699215a3da85b612b9d99516bdf12f84482f1a6f89153ec4d5ab6dd8bcf69dc512cb50080db4630a5bb52525f22213c7af92b4b77d7";

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
