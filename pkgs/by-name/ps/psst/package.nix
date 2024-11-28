{
  alsa-lib,
  atk,
  cairo,
  dbus,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gtk3,
  lib,
  makeDesktopItem,
  nix-update-script,
  pango,
  pkg-config,
  rustPlatform,
}:

let
  desktopItem = makeDesktopItem {
    name = "Psst";
    exec = "psst-gui";
    comment = "Fast and multi-platform Spotify client with native GUI";
    desktopName = "Psst";
    type = "Application";
    categories = [
      "Audio"
      "AudioVideo"
    ];
    icon = "psst";
    terminal = false;
    startupWMClass = "psst-gui";
  };

in
rustPlatform.buildRustPackage rec {
  pname = "psst";
  version = "0-unstable-2024-11-12";

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = pname;
    rev = "69314f9fe8e86d57a678ab333b08ab3ffcf2a3bb";
    hash = "sha256-11h6rheDjuwj3AgjGL5CrQWeXSYpVjI21N5yHjtcKz8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ldi9t3dG/BxL/Y9HL2G9PtCk5LGOjK5xvn85N2s5kMc=";

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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = with lib; {
    description = "Fast and multi-platform Spotify client with native GUI";
    homepage = "https://github.com/jpochyla/psst";
    license = licenses.mit;
    maintainers = with maintainers; [
      vbrandl
      peterhoeg
    ];
    mainProgram = "psst-gui";
  };
}
