{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  qt6,
  libjack2,
  alsa-lib,
  bzip2,
  libpulseaudio,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocenaudio";
  version = "3.15.3";

  src = fetchurl {
    name = "ocenaudio.deb";
    url = "https://www.ocenaudio.com/downloads/index.php/ocenaudio_debian12.deb?version=v${finalAttrs.version}";
    hash = "sha256-Nc4G+p6KLlID59kVYmlU+UE7vIPYeTqQeCEv9hrJnh0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt6.wrapQtAppsHook
    dpkg
  ];

  buildInputs = [
    xz
    qt6.qtbase
    bzip2
    libjack2
    alsa-lib
    libpulseaudio
  ];

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    cp -r opt/ocenaudio $out
    cp -r usr/share $out/share
    substituteInPlace $out/share/applications/ocenaudio.desktop \
      --replace-fail "/opt/ocenaudio/bin/ocenaudio" "ocenaudio"
    mkdir -p $out/share/licenses/ocenaudio
    mv $out/bin/ocenaudio_license.txt $out/share/licenses/ocenaudio/LICENSE
    # Create symlink bzip2 library
    ln -s ${bzip2.out}/lib/libbz2.so.1 $out/lib/libbz2.so.1.0

    runHook postInstall
  '';

  meta = {
    description = "Cross-platform, easy to use, fast and functional audio editor";
    homepage = "https://www.ocenaudio.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ onny ];
  };
})
