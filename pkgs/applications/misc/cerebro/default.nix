{ lib, stdenv, fetchurl, appimageTools, makeWrapper, electron_21, libsecret }:

stdenv.mkDerivation rec {
  pname = "cerebro";
  version = "0.11.0";

  src = fetchurl {
    url = "https://github.com/cerebroapp/cerebro/releases/download/v${version}/Cerebro-${version}.AppImage";
    sha256 = "sha256-+rjAMoQI3KTmHGFnyFoe20qIrAEi0DL3ksInFy677P8=";
  };

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications $out/share/icons/hicolor/512x512

    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/cerebro.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons/hicolor/512x512/apps $out/share/icons/hicolor/512x512

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_21}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc libsecret ]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  meta = with lib; {
    homepage = "https://www.cerebroapp.com/";
    description = "An open-source launcher to improve your productivity and efficiency";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
    maintainers = with maintainers; [ kylesferrazza ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
