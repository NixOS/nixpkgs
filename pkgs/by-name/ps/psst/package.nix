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
  pkgs,
  pkg-config,
  rustPlatform,
  stdenv,
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
  version = "0-unstable-2024-12-29";

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = "psst";
    rev = "8b9f719e770efe69cc53cc1b4a7ea88c3502980d";
    hash = "sha256-iJIPiD87iZ4OdF4io0dnk9wSUJhFhsK5u9aWsqXh0bs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0UllCmIe6oEl2Ecl4nqSk9ODdgso5ucX8T5nG3dVwbE=";

  # specify the subdirectory of the binary crate to build from the workspace
  buildAndTestSubdir = "psst-gui";

  env = {
    LIBCLANG_PATH = "${pkgs.llvmPackages_18.libclang.lib}/lib";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      atk
      cairo
      gdk-pixbuf
      glib
      gtk3
      pango
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      dbus
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

  meta = {
    description = "Spotify client with native GUI written in Rust, without Electron";
    homepage = "https://github.com/jpochyla/psst";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      vbrandl
      peterhoeg
    ];
    mainProgram = "psst-gui";
  };
}
