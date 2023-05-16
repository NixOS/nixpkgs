<<<<<<< HEAD
{ alsa-lib
, autoPatchelfHook
, fetchurl
, gtk3
, gtk4
, libnotify
, makeDesktopItem
, makeWrapper
, mesa
, nss
, lib
, libdrm
, qt5
, stdenv
, udev
, xdg-utils
=======
{ alsa-lib, autoPatchelfHook, fetchurl, gtk3, libnotify
, makeDesktopItem, makeWrapper, nss, lib, stdenv, udev, xdg-utils
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, xorg
}:

let
<<<<<<< HEAD
  version = "10.114.26-2";
=======
  bits = "x86_64";

  version = "4.11.3";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  desktopItem = makeDesktopItem rec {
    name = "Wavebox";
    exec = "wavebox";
    icon = "wavebox";
    desktopName = name;
    genericName = name;
<<<<<<< HEAD
    categories = [ "Network" "WebBrowser" ];
  };

  tarball = "Wavebox_${version}.tar.gz";

in
stdenv.mkDerivation {
  pname = "wavebox";
  inherit version;
  src = fetchurl {
    url = "https://download.wavebox.app/stable/linux/tar/${tarball}";
    sha256 = "1yk664zgahjg6n98n3kc9avcay0nqwcyq8wq231p7kvd79zazk0r";
=======
    categories = [ "Network" ];
  };

  tarball = "Wavebox_${lib.replaceStrings ["."] ["_"] (toString version)}_linux_${bits}.tar.gz";

in stdenv.mkDerivation {
  pname = "wavebox";
  inherit version;
  src = fetchurl {
    url = "https://github.com/wavebox/waveboxapp/releases/download/v${version}/${tarball}";
    sha256 = "0z04071lq9bfyrlg034fmvd4346swgfhxbmsnl12m7c2m2b9z784";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # don't remove runtime deps
  dontPatchELF = true;

<<<<<<< HEAD
  nativeBuildInputs = [ autoPatchelfHook makeWrapper qt5.wrapQtAppsHook ];

  buildInputs = with xorg; [
    libXdmcp
    libXScrnSaver
    libXtst
    libxshmfence
    libXdamage
  ] ++ [
    alsa-lib
    gtk3
    nss
    libdrm
    mesa
    gtk4
    qt5.qtbase
  ];

  runtimeDependencies = [ (lib.getLib udev) libnotify gtk4 ];
=======
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = with xorg; [
    libXdmcp libXScrnSaver libXtst
  ] ++ [
    alsa-lib gtk3 nss
  ];

  runtimeDependencies = [ (lib.getLib udev) libnotify ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase = ''
    mkdir -p $out/bin $out/opt/wavebox
    cp -r * $out/opt/wavebox

    # provide desktop item and icon
<<<<<<< HEAD
    mkdir -p $out/share/applications $out/share/icons/hicolor/128x128/apps
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s $out/opt/wavebox/product_logo_128.png $out/share/icons/hicolor/128x128/apps/wavebox.png
  '';

  postFixup = ''
    makeWrapper $out/opt/wavebox/wavebox-launcher $out/bin/wavebox \
    --prefix PATH : ${xdg-utils}/bin
=======
    mkdir -p $out/share/applications $out/share/pixmaps
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s $out/opt/wavebox/Wavebox-linux-x64/wavebox_icon.png $out/share/pixmaps/wavebox.png
  '';

  postFixup = ''
    # make xdg-open overrideable at runtime
    makeWrapper $out/opt/wavebox/Wavebox $out/bin/wavebox \
      --suffix PATH : ${xdg-utils}/bin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Wavebox messaging application";
    homepage = "https://wavebox.io";
    license = licenses.mpl20;
    maintainers = with maintainers; [ rawkode ];
<<<<<<< HEAD
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
=======
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
