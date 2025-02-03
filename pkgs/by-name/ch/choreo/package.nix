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
  pname = "Choreo";
  version = "2025.0.2";

  src = fetchFromGitHub {
    owner = "SleipnirGroup";
    repo = pname;
    rev = "v${version}";
    hash = lib.fakeHash;
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  sourceRoot = src.name;
  cargoHash = lib.fakeHash;

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = lib.fakeHash;
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

  meta = {
    homepage = "https://choreo.autos/";
    description = "A graphical tool for planning time-optimized trajectories for autonomous mobile robots in the FIRST Robotics Competition.";
    license = lib.licenses.gpl3Only;
    # maintainers = with lib.maintainers; [ supercoolspy ];
    mainProgram = "choreo";
  };
}
