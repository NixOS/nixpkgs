{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  openssl,
  pkg-config,
  freetype,
  libsoup,
  gtk3,
  webkitgtk,
  nodejs-slim,
  cargo-tauri,
  cargo,
  rustPlatform,
  rustc,
}:

buildNpmPackage rec {

  pname = "gale";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Kesomannen";
    repo = pname;
    rev = version;
    sha256 = "sha256-yo/Mcvrt/Kn1Zlz7lbL3n7eyT2L9dJA5PTGgWLuxJ9M=";
  };

  npmDepsHash = "sha256-z0ax5xCDcEtiBKIyM+zdck4tnyeO9TUSpnlB+d3+0xE=";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = src + "/src-tauri/Cargo.lock";
    outputHashes = {
      "fix-path-env-0.0.0" = "sha256-kSpWO2qMotpsYKJokqUWCUzGGmNOazaREDLjke4/CtE=";
    };
  };

  configurePhase = ''
    export HOME=$(mktemp -d)
  '';

  preBuild = ''
    cargo tauri build -b deb
  '';

  cargoRoot = "src-tauri/";

  preInstall = ''
    mv src-tauri/target/release/bundle/deb/*/data/usr/ "$out"
  '';

  prePatch = ''
    patch -p1 < ${./fix_broken_link_handler.patch}
    patch -p1 < ${./hardcode_changelog.patch}
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri
    nodejs-slim
    openssl
  ];

  buildInputs = [
    openssl
    freetype
    libsoup
    gtk3
    webkitgtk
  ];

  meta = {
    description = "Lightweight mod manager for Thunderstore written in Rust";
    homepage = "https://github.com/Kesomannen/gale";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ TestAccount666 ];
    mainProgram = "gale";
    platforms = [ "x86_64-linux" ];
  };
}
