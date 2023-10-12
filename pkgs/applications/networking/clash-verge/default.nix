{ lib
, stdenv
, fetchurl
, dpkg
, wrapGAppsHook
, autoPatchelfHook
, clash
, clash-meta
, openssl
, webkitgtk
, udev
, libayatana-appindicator
}:

stdenv.mkDerivation rec {
  pname = "clash-verge";
  version = "1.3.7";

  src = fetchurl {
    url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-+RYfGLa4d5JkLWnlYfhjCOSREVJ4ad/R36eSiNj3GIA=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
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
    rm $out/bin/{clash,clash-meta}

    runHook postInstall
  '';

  postFixup = ''
    ln -s ${lib.getExe clash} $out/bin/clash
    ln -s ${lib.getExe clash-meta} $out/bin/clash-meta
  '';

  meta = with lib; {
    description = "A Clash GUI based on tauri";
    homepage = "https://github.com/zzzgydi/clash-verge";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
    mainProgram = "clash-verge";
  };
}
