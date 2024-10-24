{ lib, fetchFromGitHub, rustPlatform, alsa-lib, atk, cairo, dbus, gdk-pixbuf, glib, gtk3, pango, pkg-config, makeDesktopItem }:

let
  desktopItem = makeDesktopItem {
    name = "Psst";
    exec = "psst-gui";
    comment = "Fast and multi-platform Spotify client with native GUI";
    desktopName = "Psst";
    type = "Application";
    categories = [ "Audio" "AudioVideo" ];
    icon = "psst";
    terminal = false;
    startupWMClass = "psst-gui";
  };

in
rustPlatform.buildRustPackage rec {
  pname = "psst";
  version = "unstable-2024-10-07";

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = pname;
    rev = "38d1c75d59848c54cb88896a93e05da3c71c7df4";
    hash = "sha256-iMtrZ1Mto3j4lFXI2Sm2R85+m8LpR7V1WoJ3X5JyF60=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cubeb-0.13.0" = "sha256-l1JkKlq2qvvLwNLJ2DrIpAFYcRQyd6F8pAflmtnaXhU=";
      "druid-0.8.3" = "sha256-hTB9PQf2TAhcLr64VjjQIr18mczwcNogDSRSN5dQULA=";
      "druid-enums-0.1.0" = "sha256-KJvAgKxicx/g+4QRZq3iHt6MGVQbfOpyN+EhS6CyDZk=";
    };
  };
  # specify the subdirectory of the binary crate to build from the workspace
  buildAndTestSubdir = "psst-gui";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    atk
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk3
    pango
  ];

  patches = [
    # Use a fixed build time, hard-code upstream URL instead of trying to read `.git`
    ./make-build-reproducible.patch
  ];

  postInstall = ''
    install -Dm444 psst-gui/assets/logo_512.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    install -Dm444 -t $out/share/applications ${desktopItem}/share/applications/*
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Fast and multi-platform Spotify client with native GUI";
    homepage = "https://github.com/jpochyla/psst";
    license = licenses.mit;
    maintainers = with maintainers; [ vbrandl peterhoeg ];
    mainProgram = "psst-gui";
  };
}
