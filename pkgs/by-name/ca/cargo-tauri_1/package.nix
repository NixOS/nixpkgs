{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  cargo-tauri_1,
  gtk3,
  libsoup_3,
  openssl,
  webkitgtk_4_1,
}:

cargo-tauri.overrideAttrs (
  newAttrs: oldAttrs: {
    version = "1.8.3";

    src = fetchFromGitHub {
      owner = "tauri-apps";
      repo = "tauri";
      rev = "tauri-v${newAttrs.version}";
      hash = "sha256-2GRiMptdztii0+F566LTHFaIh4SuHdOcIFZbNI7WI8w=";
    };

    # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
    # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
    sourceRoot = "${newAttrs.src.name}/tooling/cli";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (newAttrs)
        pname
        version
        src
        sourceRoot
        ;
      hash = "sha256-AIcfR4ROj0MXh5Yj6z+bvqou7aOnyNugUw3Pr1vuErQ=";
    };

    buildInputs = [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      gtk3
      libsoup_3
      webkitgtk_4_1
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
