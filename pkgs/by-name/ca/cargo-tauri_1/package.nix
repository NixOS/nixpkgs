{
  lib,
  stdenv,
  bzip2,
  pkg-config,
  rustPlatform,
  xz,
  zstd,
  cargo-tauri,
}:

cargo-tauri.overrideAttrs (
  finalAttrs: oldAttrs: {
    version = "1.6.6";

    src = oldAttrs.src.override {
      hash = "sha256-UE/mJ0WdbVT4E1YuUCtu80UB+1WR+KRWs+4Emy3Nclc=";
    };

    # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
    # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
    sourceRoot = "${finalAttrs.src.name}/tooling/cli";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      hash = "sha256-kAaq6Kam3e5n8569Y4zdFEiClI8q97XFX1hBD7NkUqw=";
    };

    nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [ pkg-config ];

    buildInputs = [
      # Required by `zip` in `tauri-bundler`
      bzip2
      zstd
    ]
    # Required by `rpm` in `tauri-bundler`
    ++ lib.optionals stdenv.hostPlatform.isLinux [ xz ];

    env = {
      ZSTD_SYS_USE_PKG_CONFIG = true;
    };

    passthru = {
      inherit (oldAttrs.passthru) hook;
      tests = { inherit (oldAttrs.passthru.tests) version; };
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
