{ lib
, stdenv
, fetchzip
, makeDesktopItem
, nix-update-script

, copyDesktopItems
, icoutils
, makeWrapper

, ffmpeg
, gtk2
, hunspell
, mono
, mpv
, tesseract4
}:

stdenv.mkDerivation rec {
  pname = "subtitleedit";
  version = "4.0.6";

  src = fetchzip {
    url = "https://github.com/SubtitleEdit/subtitleedit/releases/download/${version}/SE${lib.replaceStrings [ "." ] [ "" ] version}.zip";
    hash = "sha256-ipAqnF7rpSXccWkyTysUBrD0/mnv5AEA5GuxMJjW9Dg=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    copyDesktopItems
    icoutils
    makeWrapper
  ];

  runtimeLibs = lib.makeLibraryPath [
    gtk2
    hunspell
    mpv
    tesseract4
  ];

  runtimeBins = lib.makeBinPath [
    ffmpeg
    hunspell
    tesseract4
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48,256x256}/apps

    cp -r * $out/bin/
    ln -s ${hunspell.out}/lib/libhunspell*.so $out/bin/libhunspell.so
    makeWrapper "${mono}/bin/mono" $out/bin/subtitleedit \
      --add-flags "$out/bin/SubtitleEdit.exe" \
      --prefix LD_LIBRARY_PATH : ${runtimeLibs} \
      --prefix PATH : ${runtimeBins}

    wrestool -x -t 14 SubtitleEdit.exe > subtitleedit.ico
    icotool -x -i 3 -o $out/share/icons/hicolor/16x16/apps/subtitleedit.png subtitleedit.ico
    icotool -x -i 6 -o $out/share/icons/hicolor/32x32/apps/subtitleedit.png subtitleedit.ico
    icotool -x -i 9 -o $out/share/icons/hicolor/48x48/apps/subtitleedit.png subtitleedit.ico
    icotool -x -i 10 -o $out/share/icons/hicolor/256x256/apps/subtitleedit.png subtitleedit.ico

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Subtitle Edit";
      exec = "subtitleedit";
      icon = "subtitleedit";
      comment = meta.description;
      categories = [ "Video" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A subtitle editor";
    longDescription = ''
      With Subtitle Edit you can easily adjust a subtitle if it is out of sync with
      the video in several different ways. You can also use it for making
      new subtitles from scratch (using the time-line /waveform/spectrogram)
      or for translating subtitles.
    '';
    homepage = "https://nikse.dk/subtitleedit";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ ];
  };
}
