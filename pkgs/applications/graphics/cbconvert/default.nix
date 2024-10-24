{
  buildGoModule,
  bzip2,
  cbconvert,
  cbconvert-gui,
  fetchFromGitHub,
  fetchpatch,
  gtk3,
  imagemagick,
  lib,
  libunarr,
  mupdf-headless,
  nix-update-script,
  pkg-config,
  stdenv,
  testers,
  wrapGAppsHook3,
  zlib,
}:

let
  version = "1.0.4";
  generic =
    {
      buildInputs ? [ ],
      nativeBuildInputs ? [ ],
      passthru ? { },
      pname,
      vendorHash,
    }:
    buildGoModule ({
      inherit
        passthru
        pname
        vendorHash
        version
        ;

      src = fetchFromGitHub {
        owner = "gen2brain";
        repo = "cbconvert";
        rev = "v${version}";
        hash = "sha256-9x7RXyiQoV2nIVFnG1XHcYfTQiMZ88Ck7uuY7NLK8CA=";
      };

      # Update dependencies in order to use the extlib tag.
      patches = [
        (fetchpatch {
          name = "update-dependencies-1.patch";
          url = "https://github.com/gen2brain/cbconvert/commit/1a36ec17b2c012f278492d60d469b8e8457a6110.patch";
          hash = "sha256-Hv1v2qYKnIbozv49s+b3zcRqMBgdQG8wBD06H73ILE8=";
        })
        (fetchpatch {
          name = "update-dependencies-2.patch";
          url = "https://github.com/gen2brain/cbconvert/commit/74c5de699413e95133f97666b64a1866f88fedd5.patch";
          hash = "sha256-5v54irD0Celu78tbx5zp60KF4Xv5HyUjhz/BY+M+vi4=";
        })
      ];

      modRoot = "cmd/${pname}";

      proxyVendor = true;

      # The extlib tag forces the github.com/gen2brain/go-unarr module to use external libraries instead of bundled ones.
      tags = [ "extlib" ];

      ldflags = [
        "-s"
        "-w"
        "-X main.appVersion=${version}"
      ];

      nativeBuildInputs = [
        pkg-config
      ] ++ nativeBuildInputs;

      buildInputs = [
        bzip2
        imagemagick
        libunarr
        mupdf-headless
        zlib
      ] ++ buildInputs;

      meta = with lib; {
        description = "A Comic Book converter";
        homepage = "https://github.com/gen2brain/cbconvert";
        changelog = "https://github.com/gen2brain/cbconvert/releases/tag/v${version}";
        license = with licenses; [ gpl3Only ];
        platforms = with platforms; linux ++ darwin ++ windows;
        broken = !stdenv.hostPlatform.isLinux;
        maintainers = with maintainers; [ jwillikers ];
        mainProgram = "${pname}";
      };
    });
in
{
  cbconvert = generic {
    pname = "cbconvert";
    vendorHash = "sha256-aVInsWvygNH+/h7uQs4hAPOO2gsSkBx+tI+TK77M/hg=";

    passthru = {
      updateScript = nix-update-script { };
      tests.version = testers.testVersion {
        package = cbconvert;
        command = "cbconvert version";
      };
    };
  };

  cbconvert-gui = generic {
    pname = "cbconvert-gui";
    vendorHash = "sha256-vvCvKecPszhNCQdgm3mQMb5+486BGZ9sz3R0b70eLeQ=";
    nativeBuildInputs = lib.optionals (stdenv.hostPlatform.isUnix && !stdenv.hostPlatform.isDarwin) [
      wrapGAppsHook3
    ];
    buildInputs = lib.optionals (stdenv.hostPlatform.isUnix && !stdenv.hostPlatform.isDarwin) [ gtk3 ];
  };
}
