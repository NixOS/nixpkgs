{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  bun,
  nodejs,
  pkg-config,
  jq,
  wrapGAppsHook3,
  cargo-tauri,
  gtk3,
  glib,
  libsoup_3,
  webkitgtk_4_1,
  openssl,
  zstd,
  apple-sdk_15,
}:

let
  version = "26.4.2";

  src = fetchFromGitHub {
    owner = "beagleeditor";
    repo = "editor";
    tag = "v${version}";
    hash = "sha256-zNz409/PBe9rtCrQSSh1mhCCdhnZEwzPLnIF2jSYJsQ=";
  };

  frontend = stdenv.mkDerivation {
    pname = "beagleeditor-frontend";
    inherit version;
    inherit src;

    nativeBuildInputs = [
      bun
      nodejs
    ];

    buildPhase = ''
      runHook preBuild

      export HOME="$TMPDIR"
      export BUN_INSTALL_CACHE_DIR="$TMPDIR/bun-cache"

      bun install
      bun run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -r dist "$out/dist"

      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  __structuredAttrs = true;

  pname = "beagleeditor";
  inherit version src;

  sourceRoot = "source/src-tauri";

  cargoHash = "sha256-0LztXUG8puMxiYsHPHSpNIZKMvAejsldUAJN1+sT9I4=";

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
    jq
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
    glib
    libsoup_3
    webkitgtk_4_1
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  postPatch = ''
    chmod -R u+w "$NIX_BUILD_TOP/source"

    cp -r ${frontend}/dist ../dist

    jq '
      del(.build.beforeBuildCommand) |
      .bundle.createUpdaterArtifacts = false |
      .bundle.macOS += {
        signingIdentity: null,
        hardenedRuntime: false
      }
    ' tauri.conf.json > tauri.conf.json.tmp

    mv tauri.conf.json.tmp tauri.conf.json
  '';

  meta = {
    description = "A 'beagleful' editor";
    homepage = "https://github.com/beagleeditor/editor";
    license = lib.licenses.mit;
    mainProgram = "beagleeditor";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
