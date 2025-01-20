{
  stdenv,
  lib,
  fetchFromGitLab,
  cargo,
  desktop-file-utils,
  libadwaita,
  meson,
  ninja,
  openssl,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
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

    # Work around for adding unstable Rust feature
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
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libsoup_3
    openssl
    webkitgtk_6_0
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
