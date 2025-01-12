{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  vimUtils,
}:
let
  version = "0-unstable-2024-12-17";
  src = fetchFromGitHub {
    owner = "vyfor";
    repo = "cord.nvim";
    rev = "c82ab475e7bb198d6fac20833a3468de1a1d14d0";
    hash = "sha256-GVy8q9Fxb3mzx6mUQyIMumjnwZ7W08dPz1O3ckzVvdE=";
  };
  extension = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
  cord-nvim-rust = rustPlatform.buildRustPackage {
    pname = "cord.nvim-rust";
    inherit version src;

    cargoHash = "sha256-unE600Uo8fXaFV0UWRhBenhQaXftDH7K+HyQ/9xo7JY=";

    installPhase =
      let
        cargoTarget = stdenv.hostPlatform.rust.cargoShortTarget;
      in
      ''
        install -D target/${cargoTarget}/release/libcord.${extension} $out/lib/cord.${extension}
      '';
  };
in
vimUtils.buildVimPlugin {
  pname = "cord.nvim";
  inherit version src;

  nativeBuildInputs = [
    cord-nvim-rust
  ];

  buildPhase = ''
    runHook preBuild

    install -D ${cord-nvim-rust}/lib/cord.${extension} cord.${extension}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D cord $out/lua/cord.${extension}

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
      attrPath = "vimPlugins.cord-nvim.cord-nvim-rust";
    };

    # needed for the update script
    inherit cord-nvim-rust;
  };

  meta = {
    homepage = "https://github.com/vyfor/cord.nvim";
    license = lib.licenses.asl20;
  };
}
