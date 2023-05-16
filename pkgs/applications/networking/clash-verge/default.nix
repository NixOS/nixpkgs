{ lib
, stdenv
, fetchurl
, dpkg
, wrapGAppsHook
, autoPatchelfHook
<<<<<<< HEAD
, clash
, clash-meta
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, openssl
, webkitgtk
, udev
, libayatana-appindicator
}:

stdenv.mkDerivation rec {
  pname = "clash-verge";
<<<<<<< HEAD
  version = "1.3.5";

  src = fetchurl {
    url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-dMlJ7f1wpaiJrK5Xwx+e1tsWkGG9gJUyiIjhvVCWEJQ=";
  };

=======
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-AEOFMKxrkPditf5ks++tII6zeuH72Fxw/TVtZeXS3v4=";
  };

  unpackPhase = "dpkg-deb -x $src .";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    rm $out/bin/{clash,clash-meta}
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

<<<<<<< HEAD
  postFixup = ''
    ln -s ${lib.getExe clash} $out/bin/clash
    ln -s ${lib.getExe clash-meta} $out/bin/clash-meta
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A Clash GUI based on tauri";
    homepage = "https://github.com/zzzgydi/clash-verge";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
<<<<<<< HEAD
    mainProgram = "clash-verge";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
