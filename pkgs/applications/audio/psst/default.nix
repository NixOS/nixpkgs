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
<<<<<<< HEAD
  version = "unstable-2023-05-13";
=======
  version = "unstable-2022-10-13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = pname;
<<<<<<< HEAD
    rev = "f94af14aa9fdd3d59cd92849fa7f076103b37a70";
    hash = "sha256-Cmpdyec1xe7j10LDm+iCaKlBICHkmmbhKz2nDeOFOF8=";
=======
    rev = "d70ed8104533dc15bc36b989ba8428872c9b578f";
    hash = "sha256-ZKhHN0ruLb6ZVKkrKv/YawRsVop6SP1QF/nrtkmA8P8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "cubeb-0.10.3" = "sha256-3eHW+kIJydF6nF0EkB/vglOvksfol+xIKoqFsKg3omI=";
      "druid-0.8.3" = "sha256-hTB9PQf2TAhcLr64VjjQIr18mczwcNogDSRSN5dQULA=";
      "druid-enums-0.1.0" = "sha256-KJvAgKxicx/g+4QRZq3iHt6MGVQbfOpyN+EhS6CyDZk=";
=======
      "cubeb-0.10.1" = "sha256-PRQL8dq5BAsodbVlm5SnuzUDLg9/UY3BmoumcmWF+aY=";
      "druid-0.7.0" = "sha256-fnsm+KGsuePLRRjTecJ0GBQEySSeDIth13AX/aAigqU=";
      "druid-enums-0.1.0" = "sha256-4fo0ywoK+m4OuqYlbNbJS2BZK/VBFqeAYEFNGnGUVmM=";
      "piet-0.5.0" = "sha256-hCg8vABnLAO8egFwMtRSpRdzH6auETrICoUfuBZVzz8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  patches = [
    # Use a fixed build time, hard-code upstream URL instead of trying to read `.git`
    ./make-build-reproducible.patch
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    install -Dm444 psst-gui/assets/logo_512.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    install -Dm444 -t $out/share/applications ${desktopItem}/share/applications/*
  '';

<<<<<<< HEAD
  passthru = {
    updateScript = ./update.sh;
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Fast and multi-platform Spotify client with native GUI";
    homepage = "https://github.com/jpochyla/psst";
    license = licenses.mit;
    maintainers = with maintainers; [ vbrandl peterhoeg ];
  };
}
