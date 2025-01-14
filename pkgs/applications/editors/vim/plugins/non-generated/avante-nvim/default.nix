{
  lib,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  vimPlugins,
  vimUtils,
}:
let
  version = "0.0.14";
  src = fetchFromGitHub {
    owner = "yetone";
    repo = "avante.nvim";
    tag = "v${version}";
    hash = "sha256-0dkPejvupXhVZY/5qT45f4LZ4MIVcz8uZam+9TmB+Yo=";
  };
  avante-nvim-lib = rustPlatform.buildRustPackage {
    pname = "avante-nvim-lib";
    inherit version src;

    cargoHash = "sha256-80++U7CIu6QtH1jQCHCEpv2tnYOuoWSczZIUmKyrqJE=";

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      openssl
    ];

    buildFeatures = [ "luajit" ];

    checkFlags = [
      # Disabled because they access the network.
      "--skip=test_hf"
      "--skip=test_public_url"
      "--skip=test_roundtrip"
    ];
  };
in
vimUtils.buildVimPlugin {
  pname = "avante.nvim";
  inherit version src;

  dependencies = with vimPlugins; [
    dressing-nvim
    nui-nvim
    nvim-treesitter
    plenary-nvim
  ];

  postInstall =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir -p $out/build
      ln -s ${avante-nvim-lib}/lib/libavante_repo_map${ext} $out/build/avante_repo_map${ext}
      ln -s ${avante-nvim-lib}/lib/libavante_templates${ext} $out/build/avante_templates${ext}
      ln -s ${avante-nvim-lib}/lib/libavante_tokenizers${ext} $out/build/avante_tokenizers${ext}
    '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.avante-nvim.avante-nvim-lib";
    };

    # needed for the update script
    inherit avante-nvim-lib;
  };

  nvimSkipModule = [
    # Requires setup with corresponding provider
    "avante.providers.azure"
    "avante.providers.copilot"
  ];

  meta = {
    description = "Neovim plugin designed to emulate the behaviour of the Cursor AI IDE";
    homepage = "https://github.com/yetone/avante.nvim";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ttrei
      aarnphm
    ];
  };
}
