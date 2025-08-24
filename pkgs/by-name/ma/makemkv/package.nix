{
  autoPatchelfHook,
  common-updater-scripts,
  curl,
  fetchurl,
  ffmpeg,
  lib,
  stdenv,
  qt5,
  openssl,
  pkg-config,
  rubyPackages,
  writeShellApplication,
  zlib,

  withJava ? true,
  jre_headless,
}:

let
  version = "1.18.1";
  # Using two URLs as the first one will break as soon as a new version is released
  src_bin = fetchurl {
    urls = [
      "http://www.makemkv.com/download/makemkv-bin-${version}.tar.gz"
      "http://www.makemkv.com/download/old/makemkv-bin-${version}.tar.gz"
    ];
    hash = "sha256-sWV2ZR6t7DWF6BeEOioaDryqcTuJ3R4CDYsdBW3bL9Y=";
  };
  src_oss = fetchurl {
    urls = [
      "http://www.makemkv.com/download/makemkv-oss-${version}.tar.gz"
      "http://www.makemkv.com/download/old/makemkv-oss-${version}.tar.gz"
    ];
    hash = "sha256-3Efu+x5o99U55LB5u5POZBRBBK0jPeVoGJOYEOzQO3s=";
  };
in
stdenv.mkDerivation {
  pname = "makemkv";
  inherit version;

  srcs = [
    src_bin
    src_oss
  ];

  sourceRoot = "makemkv-oss-${version}";

  patches = [ ./r13y.patch ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    ffmpeg
    openssl
    qt5.qtbase
    zlib
  ];

  runtimeDependencies = [ (lib.getLib curl) ];

  qtWrapperArgs =
    let
      binPath = lib.makeBinPath [ jre_headless ];
    in
    lib.optionals withJava [ "--prefix PATH : ${binPath}" ];

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

  passthru = {
    srcs = {
      inherit src_bin src_oss;
    };
    updateScript = lib.getExe (writeShellApplication {
      name = "update-makemkv";
      runtimeInputs = [
        common-updater-scripts
        curl
        rubyPackages.nokogiri
      ];
      text = ''
        get_version() {
          # shellcheck disable=SC2016
          curl --fail --silent 'https://forum.makemkv.com/forum/viewtopic.php?f=3&t=224' \
            | nokogiri -e 'puts $_.css("head title").first.text.match(/\bMakeMKV (\d+\.\d+\.\d+) /)[1]'
        }
        oldVersion=${lib.escapeShellArg version}
        newVersion=$(get_version)
        if [[ $oldVersion == "$newVersion" ]]; then
          echo "$0: New version same as old version, nothing to do." >&2
          exit
        fi
        update-source-version makemkv "$newVersion" --source-key=passthru.srcs.src_bin
        update-source-version makemkv "$newVersion" --source-key=passthru.srcs.src_oss --ignore-same-version
      '';
    });
  };

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
    license = [
      licenses.unfree
      licenses.lgpl21
    ];
    homepage = "https://makemkv.com";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jchw ];
  };
}
