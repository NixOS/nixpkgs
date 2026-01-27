{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  bun,
  pkg-config,
  webkitgtk_4_1,
  gtk3,
  libayatana-appindicator,
  librsvg,
  openssl,
  xdotool,
  libsoup_2_4,
  dbus,
  cargo,
  rustc,
  nodejs,
  jq,
}:

rustPlatform.buildRustPackage rec {
  pname = "claudia";
  version = "0-unstable-2025-07-02";

  src = fetchFromGitHub {
    owner = "getAsterisk";
    repo = "claudia";
    rev = "f1377833b36ffde6fde49bf0d78a73e2c9972e4b";
    hash = "sha256-Gms+sQwQBy4LcHv/KprXN2borhei/sI3FLdzARJYIYs=";
  };

  cargoRoot = "src-tauri";

  cargoHash = "sha256-J4MFgXay8xUaAv0AXk+JhMwNZIYCUchJqWOSQ8Jw41s=";

  bunDeps = stdenv.mkDerivation {
    pname = "${pname}-bun-deps";
    inherit src version;
    nativeBuildInputs = [
      bun
      nodejs
    ];

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-ciY5hWt2H8eVvlvbERuTTKodXsB4LoTkzZpl0I7dmsc=";

    installPhase = ''
      cp ${src}/bun.lock .
      cp ${src}/package.json .
      mkdir -p src-tauri
      cp -r ${src}/src-tauri/* src-tauri/

      bun install --frozen-lockfile
      patchShebangs node_modules/.bin

      mkdir -p $out
      mv node_modules $out/
    '';
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    bun
    pkg-config
    cargo
    rustc
    nodejs
    jq
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    libayatana-appindicator
    librsvg
    openssl
    xdotool
    libsoup_2_4
    dbus
  ];

  preBuild = ''
    ln -s ${bunDeps}/node_modules ./node_modules
  '';

  buildPhase = ''
    runHook preBuild

    # this prevents the tauri cli from running beforeBuildCommand
    jq '.build.beforeBuildCommand = ""' src-tauri/tauri.conf.json > src-tauri/tauri.conf.json.tmp
    mv src-tauri/tauri.conf.json.tmp src-tauri/tauri.conf.json

    node ./node_modules/.bin/tsc
    node ./node_modules/.bin/vite build

    node ./node_modules/.bin/tauri build --no-bundle

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    cd src-tauri
    cargo test $cargoCheckFlags

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 target/release/claudia $out/bin/claudia
    runHook postInstall
  '';

  meta = {
    description = "Powerful GUI app and Toolkit for Claude Code";
    homepage = "https://github.com/getAsterisk/claudia";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.codebam ];
    platforms = lib.platforms.linux;
  };
}
