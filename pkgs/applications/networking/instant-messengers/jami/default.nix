{ stdenv
, lib
, callPackage
, fetchFromGitHub
, fetchzip
, ffmpeg_4
, pjsip
, opendht
, jack
, udev
, qt6Packages
}:

let
  version = "20220726.1515.da8d1da";

  src = fetchzip {
    url = "https://dl.jami.net/release/tarballs/jami_${version}.tar.gz";
    hash = "sha256-yK+xo+YpNYmmWyNAE31hiL6HLvDdEFkm8FO6LQmPCL0=";

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
  ffmpeg-jami = ffmpeg_4.overrideAttrs (old:
    let
      patch-src = src + "/daemon/contrib/src/ffmpeg/";
    in
    {
      patches = old.patches ++ (map (x: patch-src + x) (readLinesToList ./config/ffmpeg_patches));
      configureFlags = old.configureFlags
        ++ (readLinesToList ./config/ffmpeg_args_common)
        ++ lib.optionals stdenv.isLinux (readLinesToList ./config/ffmpeg_args_linux)
        ++ lib.optionals (stdenv.isx86_32 || stdenv.isx86_64) (readLinesToList ./config/ffmpeg_args_x86);
      outputs = [ "out" "doc" ];
      meta = old.meta // {
        # undefined reference to `ff_nlmeans_init_aarch64'
        broken = stdenv.isAarch64;
      };
    });

  pjsip-jami = pjsip.overrideAttrs (old:
    let
      patch-src = src + "/daemon/contrib/src/pjproject/";
    in
    rec {
      version = "4af5d666d18837abaac94c8ec6bfc84984dcf1e2";

      src = fetchFromGitHub {
        owner = "savoirfairelinux";
        repo = "pjproject";
        rev = version;
        sha256 = "sha256-ENRfQh/HCXqInTV0tu8tGQO7+vTbST6XXpptERXMACE=";
      };

      patches = old.patches ++ (map (x: patch-src + x) (readLinesToList ./config/pjsip_patches));

      configureFlags = (readLinesToList ./config/pjsip_args_common)
        ++ lib.optionals stdenv.isLinux (readLinesToList ./config/pjsip_args_linux);
    });

  opendht-jami = opendht.override {
    enableProxyServerAndClient = true;
    enablePushNotifications = true;
  };

  jami-daemon = callPackage ./daemon.nix {
    inherit version src udev jack jami-meta ffmpeg-jami pjsip-jami opendht-jami;
  };

  jami-client-qt = qt6Packages.callPackage ./client-qt.nix {
    inherit version src jami-meta ffmpeg-jami;
  };
}
