{ stdenv
, lib
, callPackage
, fetchFromGitHub
, fetchzip
, ffmpeg
, pjsip
, opendht
, jack
, udev
, qt6Packages
}:

let
  version = "20220825.0828.c10f01f";

  src = fetchzip {
    url = "https://dl.jami.net/release/tarballs/jami_${version}.tar.gz";
    hash = "sha256-axQYU7+kOFE9SnI8fR4F6NFvD9ITZ85UJhg5OVniSlg=";

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
  ffmpeg-jami = (ffmpeg.override rec {
    version = "5.0.1";
    branch = version;
    sha256 = "sha256-KN8z1AChwcGyDQepkZeAmjuI73ZfXwfcH/Bn+sZMWdY=";
    doCheck = false;
  }).overrideAttrs (old:
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
    });

  pjsip-jami = pjsip.overrideAttrs (old:
    let
      patch-src = src + "/daemon/contrib/src/pjproject/";
    in
    rec {
      version = "513a3f14c44b2c2652f9219ec20dea64b236b713";

      src = fetchFromGitHub {
        owner = "savoirfairelinux";
        repo = "pjproject";
        rev = version;
        sha256 = "sha256-93AlJGMnlzJMrJquelpHQQKjhEgfpTFXTMqkBnm87u8=";
      };

      patches = (map (x: patch-src + x) (readLinesToList ./config/pjsip_patches));

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
