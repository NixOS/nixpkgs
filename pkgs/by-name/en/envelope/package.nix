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
  libseccomp,
  lcms2,

  python3,
  webkitgtk_6_0,
  libsoup_3,
  yq,
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

    nativeBuildInputs = [ yq ];

    # Work around https://github.com/rust-lang/cargo/issues/10801
    # See https://discourse.nixos.org/t/rust-tauri-v2-error-no-matching-package-found/56751/4
    preBuild = ''
      tomlq -it '.dependencies.envelib.features += ["async_closure"]' Cargo.toml
    '';
  };

  # requires nightly features
  env.RUSTC_BOOTSTRAP = 1;

  postPatch = ''
    patchShebangs build-aux/meson-cargo-manifest.py

    # Enable feature which is unstable for the Rust version in use
    sed -i '6i #![feature(async_closure)]' envelib/src/lib.rs
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
      #sqlite
      #libseccomp
      #lcms2

      openssl
      webkitgtk_6_0
      libsoup_3
    ];

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
