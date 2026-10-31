{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  nodejs,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
  pkg-config,
  perl,
  python3,
  wrapGAppsHook4,
  openssl,
  webkitgtk_4_1,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  libayatana-appindicator,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dbx-desktop";
  version = "0.6.14";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "t8y2";
    repo = "dbx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pa2UNSMSFmv++pow1oqz+UCoq72bqhSqyv13WeXuw90=";
  };

  cargoHash = "sha256-QsamesZVtdWLOs2RAPgHtNrhCVrScI6OpZqK8+K+Mzw=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 4;
    hash = "sha256-8hA97KK+5J9w1YZpMEQuzFZnsXMuIQ0oSYySc3AVGcg=";
  };

  # updater artifacts need TAURI_SIGNING_PRIVATE_KEY
  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'

    substituteInPlace crates/dbx-core/src/jdbc.rs \
      --replace-fail '#!/usr/bin/env sh' '#!/bin/sh'
  '';

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    pkg-config
    perl
    cargo-tauri.hook
    glib
    wrapGAppsHook4
  ];

  nativeCheckInputs = [
    openssl.bin
    python3
  ];

  # Same features as upstream test CI. Some tests fail without these settings
  checkNoDefaultFeatures = true;
  checkFeatures = [
    "dbx/duckdb-sidecar"
    "dbx/dynamodb"
    "dbx/mq-admin"
    "dbx/sqlite-sqlcipher"
    "dbx/system-fonts"
    "dbx-core/duckdb-sidecar"
    "dbx-core/dynamodb"
    "dbx-core/mq-admin"
    "dbx-core/sqlite-sqlcipher"
    "dbx-core/system-fonts"
    "dbx-web/duckdb-sidecar"
    "dbx-web/dynamodb"
    "dbx-web/mq-admin"
    "dbx-web/sqlite-sqlcipher"
    "dbx-web/system-fonts"
  ];

  buildInputs = [
    webkitgtk_4_1
    openssl
    glib-networking
    gsettings-desktop-schemas
    libayatana-appindicator
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight database management tool supporting 90+ databases";
    longDescription = ''
      DBX is a lightweight (~15 MB) database management tool supporting 90+
      databases. Built with Tauri 2, Vue 3, and Rust. No Java, no Chromium.
    '';
    license = lib.licenses.asl20;
    homepage = "https://github.com/t8y2/dbx";
    changelog = "https://github.com/t8y2/dbx/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ profidev ];
    platforms = lib.platforms.linux;
    mainProgram = "dbx";
  };
})
