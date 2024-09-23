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
  version = "8";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "fractal";
    rev = "refs/tags/${version}";
    hash = "sha256-a77+lPH2eqWTLFrYfcBXSvbyyYC52zSo+Rh/diqKYx4=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "matrix-sdk-0.7.1" = "sha256-ZlkxGXGrmZ8VQV7UY7A7BBfcqFCAB9Ep7l65irx4Dy8=";
      "ruma-0.10.1" = "sha256-C/GJ0hDWJ9/grfjMuPSatJq2SrVkV0jxQlAAASkUWqg=";
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
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
    mainProgram = "fractal";
  };
}
