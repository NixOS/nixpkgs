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
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "martinber";
    repo = "noaa-apt";
    rev = "v${version}";
    sha256 = "sha256-A78O5HkD/LyfvjLJjf7PpJDuftkNbaxq7Zs5kNUaULk=";
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
    install -Dm644 -t $out/share/icons/hicolor/48x48/apps $src/debian/noaa-apt.png
    install -Dm644 -t $out/share/icons/hicolor/scalable/apps $src/debian/noaa-apt.svg
  '';

  meta = with lib; {
    description = "NOAA APT image decoder";
    homepage = "https://noaa-apt.mbernardi.com.ar/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ trepetti ];
    platforms = platforms.all;
    changelog = "https://github.com/martinber/noaa-apt/releases/tag/v${version}";
  };
}
