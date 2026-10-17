
{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  bun,
  nodejs,
  pkg-config,
  wrapGAppsHook3,
  cargo-tauri,
  gtk3,
  glib,
  libsoup_3,
  webkitgtk_4_1,
  openssl,
  zstd,
  darwin,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "beagleeditor";
  version = "26.4.1";

  src = fetchFromGitHub {
    owner = "beagleeditor";
    repo = "editor";
    tag = "v${finalAttrs.version}";
    hash = lib.fakeHash;
  };

  sourceRoot = "${finalAttrs.src.name}/src-tauri";

  cargoHash = lib.fakeHash;

  nativeBuildInputs = [
    bun
    nodejs
    pkg-config
    cargo-tauri
  ] ++ lib.optionals stdenv.isLinux [
    wrapGAppsHook3
  ];

  buildInputs =
    [
      openssl
      zstd
    ]
    ++ lib.optionals stdenv.isLinux [
      gtk3
      glib
      libsoup_3
      webkitgtk_4_1
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.WebKit
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
    ];

  preBuild = ''
    cd ..
    bun install --frozen-lockfile
    bun run build
    cd src-tauri
  '';

  buildPhase = ''
    runHook preBuild
    cargo build --release --locked
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 target/release/beagleeditor \
      "$out/bin/beagleeditor"
    runHook postInstall
  '';

  meta = {
    description = "A 'beagleful' editor";
    homepage = "https://github.com/beagleeditor/editor";
    license = lib.licenses.mit;
    mainProgram = "beagleeditor";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
