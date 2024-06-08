{ lib
, stdenv
, fetchurl
, dpkg
, wrapGAppsHook3
, autoPatchelfHook
, clash-meta
, openssl
, webkitgtk
, udev
, libayatana-appindicator
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "clash-verge";
  version = "1.3.8";

  src = fetchurl {
    url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-kOju4yaa+EKzFWDrk0iSJVoWkQMBjQG3hKLfAsqlsy8=";
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

  passthru.updateScript = nix-update-script { };

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
