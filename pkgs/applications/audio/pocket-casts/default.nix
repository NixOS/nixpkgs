{ lib
, stdenv
, fetchFromGitHub
, electron
, copyDesktopItems
, makeDesktopItem
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "pocket-casts";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "felicianotech";
    repo = "pocket-casts-desktop-app";
    rev = "v${version}";
    sha256 = "sha256-WMv2G4b7kYnWy0pz8YyI2eTdefs1mtWau+HQLiRygjE=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Pocket Casts";
      genericName = "Podcasts Listener";
      exec = "pocket-casts";
      icon = "pocket-casts";
      comment = meta.description;
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/pocket-casts $out/share/pixmaps

    cp -r main.js tray-icon.png LICENSE $out/opt/pocket-casts
    install -Dm644 icon.png $out/share/pixmaps/pocket-casts.png
    install -Dm644 icon-x360.png $out/share/pixmaps/pocket-casts-x360.png

    makeWrapper ${electron}/bin/electron $out/bin/pocket-casts \
      --add-flags $out/opt/pocket-casts/main.js

    runHook postInstall
  '';

  meta = with lib; {
    description = "Pocket Casts webapp, packaged for the Linux Desktop";
    homepage = "https://github.com/felicianotech/pocket-casts-desktop-app";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = platforms.linux;
  };
}
