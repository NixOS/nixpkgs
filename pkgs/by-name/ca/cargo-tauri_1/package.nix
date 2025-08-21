{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  gtk3,
  libsoup_2_4,
  openssl,
  pkg-config,
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

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (newAttrs)
        pname
        version
        src
        sourceRoot
        ;
      hash = "sha256-t5sR02qC06H7A2vukwyZYKA2XMVUzJrgIOYuNSf42mE=";
    };

    nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [ pkg-config ];

    buildInputs = [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      gtk3
      libsoup_2_4
      webkitgtk_4_0
    ];

    passthru = { inherit (oldAttrs.passthru) hook; };

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
