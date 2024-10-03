{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  cargo-tauri_1,
  darwin,
  gtk3,
  libsoup,
  openssl,
  webkitgtk,
}:

cargo-tauri.overrideAttrs (
  newAttrs: oldAttrs: {
    version = "1.8.0";

    src = fetchFromGitHub {
      owner = "tauri-apps";
      repo = "tauri";
      rev = "tauri-v${newAttrs.version}";
      hash = "sha256-LFgfQCcjp5WP+C/yS2i4CSaBRcNI6lAia7gx1D7fGRs=";
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
      hash = "sha256-N2P/Mitt1pZt1RqIuFgo3+GgjSAahwuqpjffnQuSmiY=";
    };

    buildInputs =
      [ openssl ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        gtk3
        libsoup
        webkitgtk
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin (
        with darwin.apple_sdk.frameworks;
        [
          CoreServices
          Security
          SystemConfiguration
        ]
      );

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
