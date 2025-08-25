{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
  electron,
  libsecret,
}:

stdenv.mkDerivation rec {
  pname = "cerebro";
  version = "0.11.0";

  src = fetchurl {
    url = "https://github.com/cerebroapp/cerebro/releases/download/v${version}/Cerebro-${version}.AppImage";
    hash = "sha256-+rjAMoQI3KTmHGFnyFoe20qIrAEi0DL3ksInFy677P8=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname src version; };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/cerebro $out/share/applications $out/share/icons/hicolor/512x512

    cp -a ${appimageContents}/{locales,resources} $out/share/cerebro
    cp -a ${appimageContents}/cerebro.desktop $out/share/applications/cerebro.desktop
    cp -a ${appimageContents}/usr/share/icons/hicolor/512x512/apps $out/share/icons/hicolor/512x512

    substituteInPlace $out/share/applications/cerebro.desktop \
      --replace 'Exec=AppRun' 'Exec=cerebro'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/cerebro \
      --add-flags $out/share/cerebro/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          stdenv.cc.cc
          libsecret
        ]
      }" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  meta = {
    homepage = "https://www.cerebroapp.com/";
    description = "Open-source launcher to improve your productivity and efficiency";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kylesferrazza ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "cerebro";
  };
}
