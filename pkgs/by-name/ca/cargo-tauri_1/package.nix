{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  cargo-tauri_1,
  gtk3,
  libsoup_2_4,
  openssl,
  webkitgtk_4_0,
}:

cargo-tauri.overrideAttrs (
  newAttrs: oldAttrs: {
    version = "1.8.1";

    src = fetchFromGitHub {
      owner = "tauri-apps";
      repo = "tauri";
      rev = "tauri-v${newAttrs.version}";
      hash = "sha256-z8dfiLghN6m95PLCMDgpBMNo+YEvvsGN9F101fAcVF4=";
    };

    # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
    # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
    sourceRoot = "${newAttrs.src.name}/tooling/cli";

    cargoDeps = rustPlatform.fetchCargoTarball {
      inherit (newAttrs)
        pname
        version
        src
        sourceRoot
        ;
      hash = "sha256-OIXC4kwGIemIL8KaqK5SUDZZrOX3PX0w3h9bNiM/pCw=";
    };

    buildInputs =
      [ openssl ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        gtk3
        libsoup_2_4
        webkitgtk_4_0
      ];

    passthru = {
      hook = cargo-tauri.hook.override { cargo-tauri = cargo-tauri_1; };
    };

    meta = {
      inherit (oldAttrs.meta)
        description
        homepage
        changelog
        license
        maintainers
        mainProgram
        ;
    };
  }
)
