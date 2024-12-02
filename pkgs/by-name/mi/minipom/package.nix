{
  lib,
  stdenv,
  rustPlatform,
  cargo-tauri,
  darwin,
  glib-networking,
  nodejs_22,
  openssl,
  pkg-config,
  wrapGAppsHook3,
  gobject-introspection,
  at-spi2-atk,
  atkmm,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  librsvg,
  libsoup_3,
  pango,
  webkitgtk_4_1,
  alsa-lib,
  zlib,
  pnpm_9,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "minipom";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "tfkhdyt";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/Xn0kndmxq2p+PgLDUMISemTwgEqQrqv7CiMErlBDng=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  sourceRoot = src.name;
  cargoHash = "sha256-w2Rw3oakZ46NaYG/mkjpO1t6MqSeF1is24sB4RbDAOc=";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-E1dfaEezU1EOGEqH+bURxgDx7mEUseKGQcVnhvoED7k=";
  };

  nativeBuildInputs =
    [
      cargo-tauri.hook

      nodejs_22
      pnpm_9.configHook

      pkg-config
      wrapGAppsHook3

      gobject-introspection
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      rustPlatform.bindgenHook
    ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      at-spi2-atk
      atkmm
      cairo
      gdk-pixbuf
      glib
      gtk3
      harfbuzz
      librsvg
      libsoup_3
      pango
      webkitgtk_4_1
      zlib
      alsa-lib
    ];

  doCheck = false; # no tests

  meta = {
    homepage = "https://github.com/tfkhdyt/minipom";
    description = "Minimalistic Pomodoro Timer GUI App";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tfkhdyt ];
    mainProgram = "minipom";
  };
}
