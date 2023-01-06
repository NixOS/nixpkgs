{ stdenv
, lib
, callPackage
, fetchFromGitHub
, fetchzip
, fetchpatch
, ffmpeg_5
, pjsip
, opendht
, jack
, udev
, qt6Packages
}:

let
  version = "20221220.0956.79e1207";

  src = fetchzip {
    url = "https://dl.jami.net/release/tarballs/jami_${version}.tar.gz";
    hash = "sha256-AQgz2GqueFG+yK42zJ9MzvP4BddGt0BFb+cIoA6Fif8=";

    stripRoot = false;
    postFetch = ''
      cd $out
      mv jami-project/daemon ./
      mv jami-project/client-qt ./
      mv jami-project/COPYING ./
      rm -r jami-project.rst jami-project
      rm daemon/contrib/tarballs/*
    '';
  };

  jami-meta = with lib; {
    homepage = "https://jami.net/";
    description = " for Jami, the free and universal communication platform that respects the privacy and freedoms of its users";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.linsui ];
  };

  readLinesToList = with builtins; file: filter (s: isString s && stringLength s > 0) (split "\n" (readFile file));
in
rec {
  pjsip-jami = pjsip.overrideAttrs (old:
    let
      patch-src = src + "/daemon/contrib/src/pjproject/";
    in
    rec {
      version = "eae25732568e600d248aa8c226271ff6b81df170";

      src = fetchFromGitHub {
        owner = "savoirfairelinux";
        repo = "pjproject";
        rev = version;
        sha256 = "sha256-N7jn4qen+PgFiVkTFi2HSWhx2QPHwAYMtnrpE/ptDVc=";
      };

      patches = (map (x: patch-src + x) (readLinesToList ./config/pjsip_patches)) ++ [
        (fetchpatch {
          name = "CVE-2022-23537.patch";
          url = "https://github.com/pjsip/pjproject/commit/d8440f4d711a654b511f50f79c0445b26f9dd1e1.patch";
          sha256 = "sha256-7ueQCHIiJ7MLaWtR4+GmBc/oKaP+jmEajVnEYqiwLRA=";
        })
        (fetchpatch {
          name = "CVE-2022-23547.patch";
          url = "https://github.com/pjsip/pjproject/commit/bc4812d31a67d5e2f973fbfaf950d6118226cf36.patch";
          sha256 = "sha256-bpc8e8VAQpfyl5PX96G++6fzkFpw3Or1PJKNPKl7N5k=";
        })
      ];

      patchFlags = [ "-p1" "-l" ];

      configureFlags = (readLinesToList ./config/pjsip_args_common)
        ++ lib.optionals stdenv.isLinux (readLinesToList ./config/pjsip_args_linux);
    });

  opendht-jami = opendht.override {
    enableProxyServerAndClient = true;
    enablePushNotifications = true;
  };

  jami-daemon = callPackage ./daemon.nix {
    inherit version src udev jack jami-meta pjsip-jami opendht-jami;
  };

  jami-client = qt6Packages.callPackage ./client.nix {
    inherit version src jami-meta;
  };
}
