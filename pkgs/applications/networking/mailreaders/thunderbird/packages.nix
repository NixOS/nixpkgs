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
      ]
      ++
        lib.optional (lib.versionAtLeast version "154" && lib.versionOlder version "154.0.1")
          (fetchpatch2 {
            # Fix Success macros colliding: https://bugzilla.mozilla.org/show_bug.cgi?id=2065007
            url = "https://github.com/mozilla-firefox/firefox/commit/f0b76eba072821d62e74ebdbd8da9243a2ce3b84.patch";
            hash = "sha256-PCTmv1ZO7ce4q5fp+WPmy5Wga5OMY4hNzqIZ7iYCcp4=";
          });
      # FIXME: let's hope that upstream will fix this soon and we can drop this hack again.
      # https://bugzilla.mozilla.org/show_bug.cgi?id=2040877
      extraPostPatch =
        lib.optionalString (lib.versionAtLeast version "151" && lib.versionOlder version "152") ''
          echo https://hg.mozilla.org/releases/comm-release/rev/becfb8fb2c70f1603882a2787e2170d5d8013949 >> sourcestamp.txt
          echo https://hg.mozilla.org/releases/mozilla-release/rev/fc12dc911f904307729760a817deb829cbf8feb4 >> sourcestamp.txt
        ''
        # https://bugzilla.mozilla.org/show_bug.cgi?id=2006630
        + lib.optionalString (lib.versionAtLeast version "140.8" && lib.versionOlder version "151") ''
          find . -name .cargo-checksum.json | xargs sed 's/"[^"]*\.gitmodules":"[a-z0-9]*",//g' -i
        '';

      meta = {
        changelog = "https://www.thunderbird.net/en-US/thunderbird/${version}/releasenotes/";
        description = "Full-featured e-mail client";
        homepage = "https://www.thunderbird.net/";
        donationPage = "https://www.thunderbird.net/donate/";
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
      (
        {
          enableLocation = false;
          enableWebRTC = false;

          enablePGO = false; # console.warn: feeds: "downloadFeed: network connection unavailable"
        }
        // lib.optionalAttrs (lib.versionAtLeast version "149") {
          # https://bugzilla.mozilla.org/show_bug.cgi?id=2025767
          enableCrashReporter = false;
        }
      );

in
rec {
  thunderbird = thunderbird-latest;

  thunderbird-latest = common {
    version = "155.0";
    sha512 = "fe0247ac50d2741a49517fabe729dc990a66e7044f450e4fe6871b663096bcd15f22ed83eea0557106d38eee34e464fead5a7567d0906995ff2a945fae64b60c";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-latest";
    };
  };

  # Eventually, switch to an updateScript without versionPrefix hardcoded...
  thunderbird-esr = thunderbird-153;

  thunderbird-153 = common {
    applicationName = "Thunderbird ESR";

    version = "153.1.1esr";
    sha512 = "a0e26fb0c4c6c97ab2cc0dca0f122de9f149e70ed888010dd79192f838caa267b80bdc9e33fdcd9d8cbb3efd7ac8c63ca5b36058a5c40fe1e9f638387e7f20de";

    updateScript = callPackage ./update.nix {
      attrPath = "thunderbirdPackages.thunderbird-153";
      versionPrefix = "153";
      versionSuffix = "esr";
    };
  };

  thunderbird-140 = common {
    applicationName = "Thunderbird ESR";

    version = "140.15.0esr";
    sha512 = "52f014fb75ac131780aba924dd973a1fb5d6a60be4f800c258dca931e2c6ad75baaad37a5ad52228e91d3d174823b6b4d38ddc2dbbf9c04b8700cc33079448bb";

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
