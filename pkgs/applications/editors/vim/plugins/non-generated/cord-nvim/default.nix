{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  vimUtils,
}:
let
  version = "2.3.2-unstable-2024-12-22";
  src = fetchFromGitHub {
    owner = "vyfor";
    repo = "cord.nvim";
    rev = "8ead1d237ddfc157b593262f29804b169fdf238c";
    hash = "sha256-zdRNFT2fqEHYiARR0qX8F6P5kTuiz5GOGDsLH/yVrlo=";
  };
  extension = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
  cord-nvim-rust = rustPlatform.buildRustPackage {
    pname = "cord.nvim-rust";
    inherit version src;

    cargoHash = "sha256-Gky5vmdxMCcOy6ER86rU+66gf9DsWuZixHs0lKxD3XQ=";

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

  doInstallCheck = true;
  nvimRequireCheck = "cord";

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
