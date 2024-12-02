{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, atk
, cairo
, gdk-pixbuf
, glib
, gtk3
, openssl
, pango
}:

rustPlatform.buildRustPackage rec {
  pname = "noaa-apt";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "martinber";
    repo = "noaa-apt";
    rev = "v${version}";
    sha256 = "sha256-wmjglF2+BFmlTfvqt90nbCxuldN8AEFXj7y9tgTvA2Y=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    openssl
    pango
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "satellite-0.1.0" = "sha256-R5Tz4MpRnAEnMmkx/LhWPmwRIKpnCLIB4VxApMTBn78=";
    };
  };

  preBuild = ''
    # Used by macro pointing to resource location at compile time.
    export NOAA_APT_RES_DIR=$out/share/noaa-apt
  '';

  postInstall = ''
    # Resources.
    mkdir -p $out/share/noaa-apt
    cp -R $src/res/* $out/share/noaa-apt/

    # Desktop icon.
    install -Dm644 -t $out/share/applications $src/debian/ar.com.mbernardi.noaa-apt.desktop
    install -Dm644 -t $out/share/icons/hicolor/48x48/apps $src/debian/ar.com.mbernardi.noaa-apt.png
    install -Dm644 -t $out/share/icons/hicolor/scalable/apps $src/debian/ar.com.mbernardi.noaa-apt.svg
  '';

  meta = with lib; {
    description = "NOAA APT image decoder";
    homepage = "https://noaa-apt.mbernardi.com.ar/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ trepetti tmarkus ];
    platforms = platforms.all;
    changelog = "https://github.com/martinber/noaa-apt/releases/tag/v${version}";
    mainProgram = "noaa-apt";
  };
}
