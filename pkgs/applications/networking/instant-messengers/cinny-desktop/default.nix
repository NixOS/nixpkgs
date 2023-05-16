<<<<<<< HEAD
{ lib
, fetchFromGitHub
, rustPlatform
, cinny
, copyDesktopItems
, wrapGAppsHook
, pkg-config
, openssl
, dbus
, glib
, glib-networking
, webkitgtk
, makeDesktopItem
}:

rustPlatform.buildRustPackage rec {
  pname = "cinny-desktop";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny-desktop";
    rev = "v${version}";
    hash = "sha256-RW6LeItIAHJk1e7qMa1MLIGb3jHvJ/KM8E9l1qR48w8=";
  };

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-Iab/icQ9hFVh/o6egZVPa2zeKgO5WxzkluhRckcayvw=";

  postPatch = ''
    substituteInPlace tauri.conf.json \
      --replace '"distDir": "../cinny/dist",' '"distDir": "${cinny}",'
  '';

  postInstall = ''
    install -DT icons/128x128@2x.png $out/share/icons/hicolor/256x256@2/apps/cinny.png
    install -DT icons/128x128.png $out/share/icons/hicolor/128x128/apps/cinny.png
    install -DT icons/32x32.png $out/share/icons/hicolor/32x32/apps/cinny.png
  '';

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook
    pkg-config
  ];

  buildInputs = [
    openssl
    dbus
    glib
    glib-networking
    webkitgtk
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "cinny";
      exec = "cinny";
      icon = "cinny";
      desktopName = "Cinny";
      comment = meta.description;
      categories = [ "Network" "InstantMessaging" ];
    })
  ];
=======
{ stdenv
, lib
, dpkg
, fetchurl
, autoPatchelfHook
, glib-networking
, openssl
, webkitgtk
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "cinny-desktop";
  version = "2.2.6";

  src = fetchurl {
    url = "https://github.com/cinnyapp/cinny-desktop/releases/download/v${version}/Cinny_desktop-x86_64.deb";
    sha256 = "sha256-Bh7qBlHh2bQ6y2HnI4TtxMU6N3t04tr1Juoul2KMrqs=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    glib-networking
    openssl
    webkitgtk
    wrapGAppsHook
  ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = "mv usr $out";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Yet another matrix client for desktop";
    homepage = "https://github.com/cinnyapp/cinny-desktop";
    maintainers = [ maintainers.aveltras ];
    license = licenses.agpl3Only;
<<<<<<< HEAD
=======
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
    mainProgram = "cinny";
  };
}
