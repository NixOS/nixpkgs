{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  qt5,
  libusb1,
  pname,
  version,
  url,
  hash,
}:

stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    name = "XPPenLinux${version}.tar.gz";
    extension = "tar.gz";
    inherit url hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
    libusb1
  ];

  dontConfigure = true;
  dontBuild = true;
  dontCheck = true;

  installPhase = ''
    runHook preInstall

    rm -r App/usr/lib/pentablet/{lib,platforms,PenTablet.sh}
    mkdir -p $out/{bin,usr}
    cp -r App/lib $out/lib
    cp -r App/usr/share $out/share
    cp -r App/usr/lib $out/usr/lib

    # hack: edit the binary directly
    # TODO: replace it with buildFHSEnv if possible? last time it caused other issues
    sed -i 's#/usr/lib/pentablet#/var/lib/pentablet#g' $out/usr/lib/pentablet/PenTablet
    ln -s $out/usr/lib/pentablet/PenTablet $out/bin/PenTablet

    substituteInPlace $out/share/applications/xppentablet.desktop \
      --replace-fail "/usr/lib/pentablet/PenTablet.sh" "PenTablet" \
      --replace-fail "/usr/share/icons/hicolor/256x256/apps/xppentablet.png" "xppentablet"

    runHook postInstall
  '';

  meta = {
    description = "XPPen driver";
    downloadPage = "https://www.xp-pen.com/download/";
    homepage = "https://www.xp-pen.com/";
    license = lib.licenses.unfree;
    mainProgram = "PenTablet";
    maintainers = with lib.maintainers; [
      gepbird
      nasrally
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
