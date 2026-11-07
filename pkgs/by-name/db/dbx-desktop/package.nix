{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
  pkg-config,
  perl,
  python3,
  cacert,
  wrapGAppsHook4,
  openssl,
  webkitgtk_4_1,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  libayatana-appindicator,
  nix-update-script,
  runtimeShell,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dbx-desktop";
  version = "0.6.62";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "t8y2";
    repo = "dbx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+LZTnePyRdDb6tw3fPGvpJiWT+hmPbcvaa36YmXXNGw=";
  };

  cargoHash = "sha256-xlVIUHpmkx5rzufyPTYHZeE1fQgukOjNHY8LKgFArCQ=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-lBkJNxk39G07brqQs2+W+jnoKd7Gi511VpxBq0A95kE=";
  };

  # updater artifacts need TAURI_SIGNING_PRIVATE_KEY
  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'

    patchShebangs .

    # tests write scripts from string literals and a non-executable fixture, out of patchShebangs reach
    grep -rlE '#!/usr/bin/(env )?(python3|sh)' crates | xargs sed -i -E \
      -e 's|#!/usr/bin/(env )?python3|#!${python3.interpreter}|' \
      -e 's|#!/usr/bin/env sh|#!${runtimeShell}|'

    substituteInPlace crates/dbx-platform/src/relaunch.rs \
      --replace-fail '"/usr/bin/false"' '"false"' \
      --replace-fail '"/bin/echo"' '"echo"'
  '';

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
    pkg-config
    perl
    cargo-tauri.hook
    glib
    wrapGAppsHook4
  ];

  nativeCheckInputs = [
    cacert
    openssl.bin
    python3
  ];

  # release profile (lto, codegen-units = 1) OOMs on the test build; upstream CI tests with dev profile and uses nextest
  checkType = "debug";
  useNextest = true;
  # debug test frames overflow libtest default 2 MiB thread stack (also set in upstream CI)
  preCheck = ''
    export RUST_MIN_STACK=8388608
  '';

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
