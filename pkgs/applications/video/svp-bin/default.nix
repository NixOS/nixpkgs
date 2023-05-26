{ lib
, stdenvNoCC
, autoPatchelfHook
, avahi
, fetchurl
, libusb
, ocl-icd
, p7zip
, python38
, qtbase
, vapoursynth
, wrapQtAppsHook
, xorg
}:

stdenvNoCC.mkDerivation rec {
  pname = "svp-bin";
  version = "4.5.210";
  versionSuffix = "-2";

  src = fetchurl {
    url = "https://www.svp-team.com/files/svp4-linux.${version}${versionSuffix}.tar.bz2";
    hash = "sha256-dY9uQ9jzTHiN2XSnOrXtHD11IIJW6t9BUzGGQFfZ+yg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapQtAppsHook
    p7zip
  ];

  buildInputs = [
    avahi
    libusb
    ocl-icd
    python38
    qtbase
    vapoursynth
    xorg.libX11
  ];

  dontStrip = true;

  # Work around the "unpacker appears to have produced no directories"
  sourceRoot = ".";

  postUnpack = ''
    echo "Finding 7z archives in installer..."
    grep --only-matching --byte-offset --binary --text  $'7z\xBC\xAF\x27\x1C' "svp4-linux-64.run" |
      cut -f1 -d: |
      while read ofs; do dd if="svp4-linux-64.run" bs=1M iflag=skip_bytes status=none skip=$ofs of="bin-$ofs.7z"; done

    echo "Extracting 7z archives from installer..."
    for f in *.7z; do
      7z -bd -bb0 -y x -o"extracted/" "$f" || true
    done
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{opt/svp,/bin,/share/licenses/svp}
    mv "extracted/licenses" "$out/share/licenses/"
    mv "extracted/"* "$out/opt/"
    ln -s "$out/opt/SVPManager" "$out/bin/SVPManager"

    runHook postInstall
  '';

  preFixup = ''
    patchelf \
      --replace-needed "libQtWebApp.so.1" \
      "$out/opt/extensions/libQtWebApp.so" \
      "$out/opt/extensions/libsvpcast.so"
    patchelf \
      --replace-needed "libQtZeroConf.so.1" \
      "$out/opt/extensions/libQtZeroConf.so" \
      "$out/opt/extensions/libsvpcast.so"
    patchelf \
      --replace-needed "libPythonQt.so.1" \
      "$out/opt/extensions/libPythonQt.so" \
      "$out/opt/extensions/libsvptube.so"
  '';

  meta = with lib; {
    description = "SmoothVideo Project converts any video to 60 fps (and even higher) in real time";
    homepage = "https://www.svp-team.com/";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thiagokokada ];
  };
}
