{
  lib,
  stdenv,
  fetchFromGitLab,
  appstream,
  blueprint-compiler,
  cairo,
  cargo,
  darwin,
  desktop-file-utils,
  gdk-pixbuf,
  gettext,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  openssl,
  pango,
  pkg-config,
  rustc,
  rustPlatform,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "pipeline";
  version = "1.15.0";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "pipeline";
    rev = "v${version}";
    hash = "sha256-tZyAQz7mhd+YXaO6+XYpUxza5ViVELE3J0Zeu11fr/U=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "piped-openapi-sdk-1.0.0" = "sha256-UFzMYYqCzO6KyJvjvK/hBJtz3FOuSC2gWjKp72WFEGk=";
      "tf_core-0.1.4" = "sha256-IW5d0mn/olgm9ydN45ZaDd5AQSGj2kM7QvCHgZSnd8w=";
    };
  };

  nativeBuildInputs = [
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    meson
    gettext
    glib
    pkg-config
    desktop-file-utils
    appstream
    ninja
    rustc
    cargo
    openssl
    blueprint-compiler
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
    pango
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  postInstall = ''
    ln -s $out/bin/tubefeeder $out/bin/pipeline
  '';

  meta = {
    description = "Watch YouTube and PeerTube videos in one place";
    homepage = "https://gitlab.com/schmiddi-on-mobile/pipeline";
    changelog = "https://gitlab.com/schmiddi-on-mobile/pipeline/-/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "pipeline";
    platforms = lib.platforms.all;
  };
}
