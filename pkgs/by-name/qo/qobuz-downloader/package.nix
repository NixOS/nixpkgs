{ lib
, at-spi2-atk
, autoPatchelfHook
, cairo
, dpkg
, ffmpeg
, gdk-pixbuf
, glib
, gtk3
, makeWrapper
, pango
, requireFile
, stdenv
, xdg-user-dirs
}:

stdenv.mkDerivation {
  pname = "qobuz-downloader";
  version = "1.0.32"; # see usr/share/qobuz_downloader/data/flutter_assets/version.json

  src = requireFile {
    name = "qobuz_downloader.deb";
    url = "https://drive.google.com/file/d/1qsKOudlxwhLYxDVHqT17YDwcikoErrmj/view";
    sha256 = "098ywxydszhbimp6hxdr3rcqp9wsbrpvlzczx2xxdjflfcmlqsk4";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    at-spi2-atk
    cairo
    ffmpeg
    gdk-pixbuf
    glib
    gtk3
    pango
  ];

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc source";

  postPatch = ''
    # reduce closure size
    rm usr/share/qobuz_downloader/data/flutter_assets/assets/tools/{ffmpeg.exe,id3-tag-cli,id3-tag-cli.exe}
    # unvendor ffmpeg
    rm usr/share/qobuz_downloader/data/flutter_assets/assets/tools/ffmpeg
    ln -s ${ffmpeg}/bin/ffmpeg usr/share/qobuz_downloader/data/flutter_assets/assets/tools/ffmpeg
    # TODO: unvendor id3-tag-cli
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out
  '';

  preFixup = ''
    makeWrapper $out/share/qobuz_downloader/qobuz_downloader $out/bin/qobuz_downloader \
      --suffix PATH : ${lib.makeBinPath [ xdg-user-dirs ]}
  '';

  meta = with lib; {
    description = "";
    downloadPage = "https://www.qobuz.com/gb-en/discover/apps-partners";
    license = with licenses; [ unfree ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ sersorrel ];
    mainProgram = "qobuz_downloader";
    platforms = [ "x86_64-linux" ];
  };
}
