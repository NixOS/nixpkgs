{
  stdenv,
  lib,
  fetchFromGitLab,
  cargo,
  dbus,
  desktop-file-utils,
  gdk-pixbuf,
  gettext,
  gitMinimal,
  glib,
  gst_all_1,
  gtk4,
  libadwaita,
  meson,
  ninja,
  openssl,
  pkg-config,
  rustPlatform,
  rustc,
  sqlite,
  wrapGAppsHook4,
  libshumate,
  libseccomp,
  lcms2,
  nix-update-script,

  python3,
  webkitgtk_6_0,
  libsoup_3,
}:

stdenv.mkDerivation rec {
  pname = "envelope";
  version = "0-unstable-2025-01-17";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "felinira";
    repo = "envelope";
    rev = "fec20b872cf440dd7c2928ea2b189752be6b7678";
    hash = "sha256-Wy80ljCrP3LNaQqR75rN2uTiF0BKfA3vPx5Fk/w+5BA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-OTkiX7u36hi1OcwSurfBCCX0BoVyJcTBQrZrQ9pGOfE=";
  };

  # requires nightly features
  #RUSTC_BOOTSTRAP = 1;
  env.RUSTC_BOOTSTRAP = 1;

  postPatch = ''
    patchShebangs build-aux/meson-cargo-manifest.py
  '';

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gitMinimal
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4

    python3
  ];

  buildInputs =
    [
      dbus
      gdk-pixbuf
      glib
      gtk4
      libadwaita
      openssl
      sqlite
      libshumate
      libseccomp
      lcms2

      webkitgtk_6_0
      libsoup_3
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
    ]);

  meta = {
    description = "a mobile-first email client for the GNOME ecosystem";
    homepage = "https://gitlab.gnome.org/felinira/envelope";
    maintainers = with lib.maintainers; [ onny ];
    license = with lib.licenses; [
      cc0
      gpl3Plus
      mpl20
    ];
    platforms = lib.platforms.linux;
    mainProgram = "envelope";
  };
}
