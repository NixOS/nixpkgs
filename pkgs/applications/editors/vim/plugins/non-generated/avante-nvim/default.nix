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
  makeWrapper,
  perl,
}:
let
  version = "0.2.3";
  src = fetchFromGitHub {
    owner = "yetone";
    repo = "avante.nvim";
    tag = "v${version}";
    hash = "sha256-VJN2ero5ndLqfmMImUF9fqbUKku6Q1CypjK5Q+SB0ck=";
  };
  avante-nvim-lib = rustPlatform.buildRustPackage {
    pname = "avante-nvim-lib";
    inherit version src;

    cargoHash = "sha256-F0SJ4iv/oL2560KmqH7Sun3F+yXR44daYFbOQRsYlDg=";

    nativeBuildInputs = [
      pkg-config
      makeWrapper
      perl
    ];

    buildInputs = [
      openssl
    ];

    buildFeatures = [ "luajit" ];

    # Allow undefined symbols on Darwin - they will be provided by Neovim's LuaJIT runtime
    env.RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-C link-arg=-undefined -C link-arg=dynamic_lookup";

    checkFlags = [
      # Disabled because they access the network.
      "--skip=test_hf"
      "--skip=test_public_url"
      "--skip=test_roundtrip"
      "--skip=test_fetch_md"
    ];
  };
in
vimUtils.buildVimPlugin {
  pname = "avante.nvim";
  inherit version src;

  dependencies = with vimPlugins; [
    dressing-nvim
    img-clip-nvim
    nui-nvim
    nvim-treesitter
    plenary-nvim
  ];

  postInstall =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      # place dynamic shared libraries directly into lua/ for native C-module discovery
      mkdir -p $out/lua
      cp ${avante-nvim-lib}/lib/libavante_repo_map${ext} $out/lua/avante_repo_map${ext}
      cp ${avante-nvim-lib}/lib/libavante_templates${ext} $out/lua/avante_templates${ext}
      cp ${avante-nvim-lib}/lib/libavante_tokenizers${ext} $out/lua/avante_tokenizers${ext}
      cp ${avante-nvim-lib}/lib/libavante_html2md${ext} $out/lua/avante_html2md${ext}
    '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.avante-nvim.avante-nvim-lib";
    };

    # needed for the update script
    inherit avante-nvim-lib;
  };

  nvimSkipModules = [
    # Requires setup with corresponding provider
    "avante.providers.azure"
    "avante.providers.copilot"
    "avante.providers.gemini"
    "avante.providers.vertex"
    "avante.providers.vertex_claude"
  ];

  meta = {
    description = "Neovim plugin designed to emulate the behaviour of the Cursor AI IDE";
    homepage = "https://github.com/yetone/avante.nvim";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ttrei
      aarnphm
      jackcres
    ];
  };
}
