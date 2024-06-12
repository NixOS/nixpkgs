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
  version = "7";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "fractal";
    rev = "refs/tags/${version}";
    hash = "sha256-IfcThpsGATMD3Uj9tvw/aK7IVbiVT8sdZ088gRUqnlg=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "mas-http-0.8.0" = "sha256-IiYxF9qT/J/n8t/cVT/DRV3gl2MTA6/YfjshVIic/n4=";
      "matrix-sdk-0.7.1" = "sha256-quwt9Dx0K6LDMwHBipc52Ek59zz5mlTAdOj+RXZBU3Q=";
      "ruma-0.9.4" = "sha256-tp0EFS39UTXZJQPUDjeQixb8wzsMCzyFggVj6M8TRYg=";
      "vodozemac-0.5.1" = "sha256-Hm0C696RmNX6n1Jx+hqkKMjpdbArliuzdiS4wCv3OIM=";
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
