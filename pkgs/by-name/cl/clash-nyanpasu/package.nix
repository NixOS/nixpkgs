{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  clash-meta,
  openssl,
  webkitgtk,
  udev,
  libayatana-appindicator,
}:

stdenv.mkDerivation rec {
  pname = "clash-nyanpasu";
  version = "1.4.5";

  src = fetchurl {
    url = "https://github.com/keiko233/clash-nyanpasu/releases/download/v${version}/clash-nyanpasu_${version}_amd64.deb";
    hash = "sha256-cxaq7Rndf0ytEaqc7CGQix5SOAdsTOoTj1Jlhjr5wEA=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    openssl
    webkitgtk
    stdenv.cc.cc
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv usr/* $out

    runHook postInstall
  '';

  postFixup = ''
    rm -f $out/bin/clash
    ln -sf ${lib.getExe clash-meta} $out/bin/${clash-meta.meta.mainProgram}
  '';

  meta = with lib; {
    description = "Clash GUI based on tauri";
    homepage = "https://github.com/LibNyanpasu/clash-nyanpasu";
    license = licenses.gpl3Plus;
    mainProgram = "clash-nyanpasu";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ Guanran928 ];
  };
}
