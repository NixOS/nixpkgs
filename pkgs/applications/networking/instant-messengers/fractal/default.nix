{ stdenv
, lib
, fetchFromGitLab
, nix-update-script
, cargo
, meson
, ninja
, rustPlatform
, rustc
, pkg-config
, glib
, gtk4
, gtksourceview5
, libadwaita
, gst_all_1
, desktop-file-utils
, appstream-glib
, openssl
, pipewire
, libshumate
, wrapGAppsHook4
, sqlite
, xdg-desktop-portal
}:

stdenv.mkDerivation rec {
  pname = "fractal";
  version = "6";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
    hash = "sha256-J4Jb7G5Rfou3N7mytetIdLl0dGY5dSvTjnu8aj4kWXQ=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "matrix-sdk-0.6.2" = "sha256-CY0Ylrd3NkP1IevyQa351IS/+evG2GgrjPnR/ZDFR9Q=";
    };
  };

  nativeBuildInputs = [
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
    desktop-file-utils
    appstream-glib
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    gtksourceview5
    libadwaita
    openssl
    pipewire
    libshumate
    sqlite
    xdg-desktop-portal
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gst-plugins-good
  ]);

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Matrix group messaging app";
    homepage = "https://gitlab.gnome.org/GNOME/fractal";
    changelog = "https://gitlab.gnome.org/World/fractal/-/releases/${version}";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ anselmschueler dtzWill ]);
    platforms = platforms.linux;
    mainProgram = "fractal";
  };
}
