{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, pkg-config
, dpkg
, openssl
, webkitgtk
, libappindicator
, wrapGAppsHook
<<<<<<< HEAD
, shared-mime-info
, glib-networking
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  name = "holochain-launcher";
<<<<<<< HEAD
  version = "0.11.0";
  prerelease = "beta-2";

  src = fetchurl {
    url = "https://github.com/holochain/launcher/releases/download/v${version}/holochain-launcher-${prerelease}_${version}_amd64.deb";
    sha256 = "sha256-yxovSsPyIzFONa1ACeLkZqDCElDI3uTm81YOYW0/FXE=";
=======
  version = "0.9.4";

  src = fetchurl {
    url = "https://github.com/holochain/launcher/releases/download/v${version}/holochain-launcher_${version}_amd64.deb";
    sha256 = "sha256-qTzm4pwhYbEN96a/Dz/JcJcZ2OobyQJRNC2yH4CbhzQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook # required for FileChooser
  ];

  buildInputs = [
    openssl
    webkitgtk
    libappindicator
<<<<<<< HEAD

    glib-networking
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = ''
    mv usr $out
<<<<<<< HEAD
    mv $out/bin/holochain-launcher-${prerelease} $out/bin/holochain-launcher
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  preFixup = ''
    patchelf --add-needed "libappindicator3.so" "$out/bin/holochain-launcher"
<<<<<<< HEAD

    # without this the DevTools will just display an unparsed HTML file (see https://github.com/tauri-apps/tauri/issues/5711#issuecomment-1336409601)
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    )
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "A cross-platform executable that launches a local Holochain conductor, and installs and opens apps";
    homepage = "https://github.com/holochain/launcher";
    maintainers = [ maintainers.steveej ];
    license = licenses.cal10;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
  };
}
