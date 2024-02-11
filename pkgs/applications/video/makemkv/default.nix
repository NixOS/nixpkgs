{ lib
, mkDerivation
, fetchurl
, autoPatchelfHook
, pkg-config
, curl
, ffmpeg
, openssl
, qtbase
, zlib

, withJava ? true
, jre_headless
}:

let
  version = "1.17.6";
  # Using two URLs as the first one will break as soon as a new version is released
  src_bin = fetchurl {
    urls = [
      "http://www.makemkv.com/download/makemkv-bin-${version}.tar.gz"
      "http://www.makemkv.com/download/old/makemkv-bin-${version}.tar.gz"
    ];
    sha256 = "KHZGAFAp93HTZs8OT76xf88QM0UtlVVH3q57CZm07Rs=";
  };
  src_oss = fetchurl {
    urls = [
      "http://www.makemkv.com/download/makemkv-oss-${version}.tar.gz"
      "http://www.makemkv.com/download/old/makemkv-oss-${version}.tar.gz"
    ];
    sha256 = "2dtNdyv0+QYWQrfrIu5RQKSN4scSWKuLFNlJZXpxDUM=";
  };

in mkDerivation {
  pname = "makemkv";
  inherit version;

  srcs = [ src_bin src_oss ];

  sourceRoot = "makemkv-oss-${version}";

  patches = [ ./r13y.patch ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoPatchelfHook pkg-config ];

  buildInputs = [ ffmpeg openssl qtbase zlib ];

  runtimeDependencies = [ (lib.getLib curl) ];

  qtWrapperArgs =
    let
      binPath = lib.makeBinPath [ jre_headless ];
    in lib.optionals withJava [
      "--prefix PATH : ${binPath}"
    ];

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin                              out/makemkv out/mmccextr out/mmgplsrv ../makemkv-bin-${version}/bin/amd64/makemkvcon
    install -D     -t $out/lib                              out/lib{driveio,makemkv,mmbd}.so.*
    install -D     -t $out/share/MakeMKV                    ../makemkv-bin-${version}/src/share/*
    install -Dm444 -t $out/share/applications               ../makemkv-oss-${version}/makemkvgui/share/makemkv.desktop
    install -Dm444 -t $out/share/icons/hicolor/16x16/apps   ../makemkv-oss-${version}/makemkvgui/share/icons/16x16/*
    install -Dm444 -t $out/share/icons/hicolor/32x32/apps   ../makemkv-oss-${version}/makemkvgui/share/icons/32x32/*
    install -Dm444 -t $out/share/icons/hicolor/64x64/apps   ../makemkv-oss-${version}/makemkvgui/share/icons/64x64/*
    install -Dm444 -t $out/share/icons/hicolor/128x128/apps ../makemkv-oss-${version}/makemkvgui/share/icons/128x128/*
    install -Dm444 -t $out/share/icons/hicolor/256x256/apps ../makemkv-oss-${version}/makemkvgui/share/icons/256x256/*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Convert blu-ray and dvd to mkv";
    longDescription = ''
      makemkv is a one-click QT application that transcodes an encrypted
      blu-ray or DVD disc into a more portable set of mkv files, preserving
      subtitles, chapter marks, all video and audio tracks.

      Program is time-limited -- it will stop functioning after 60 days. You
      can always download the latest version from makemkv.com that will reset the
      expiration date.
    '';
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = [ licenses.unfree licenses.lgpl21 ];
    homepage = "http://makemkv.com";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ titanous ];
  };
}
