{
  lib,
  stdenv,
  makeWrapper,
  mkShell,
  rustPlatform,
  clippy,
  rustfmt,
  libiconv,
  nix,
  nix-prefetch-git,
}:

let
  convert-to-import-cargo-lock = rustPlatform.buildRustPackage {
    name = "convert-to-import-cargo-lock";

    src = lib.fileset.toSource {
      root = ./.;
      fileset = lib.fileset.unions [
        ./Cargo.lock
        ./Cargo.toml
        ./src/main.rs
      ];
    };

    nativeBuildInputs = [ makeWrapper ];

    # This tool makes use of `nix` (and its helpers) and `nix-prefetch-git`.
    postInstall = ''
      wrapProgram $out/bin/convert-to-import-cargo-lock \
        --suffix PATH : ${
          lib.makeBinPath [
            nix
            nix-prefetch-git
          ]
        }
    '';

    cargoLock.lockFile = ./Cargo.lock;

    passthru.shell = mkShell {
      inputsFrom = [ convert-to-import-cargo-lock ];
      packages = [
        clippy
        rustfmt
      ] ++ lib.optional stdenv.isDarwin libiconv;
    };
  };
in
convert-to-import-cargo-lock
