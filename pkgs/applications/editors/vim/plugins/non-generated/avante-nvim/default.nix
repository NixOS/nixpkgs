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
  pkgs,
}:
let
  version = "0.0.27-unstable-2026-02-23";
  src = fetchFromGitHub {
    owner = "yetone";
    repo = "avante.nvim";
    rev = "2475e71982cadc8d38ba20b9b6112873f33caf31";
    hash = "sha256-vgMDC005PrSJBMpoqqxSmth6tCG4YZfTAQz2475Po6E=";
  };
  avante-nvim-lib = rustPlatform.buildRustPackage {
    pname = "avante-nvim-lib";
    inherit version src;

    cargoHash = "sha256-pTWCT2s820mjnfTscFnoSKC37RE7DAPKxP71QuM+JXQ=";

    nativeBuildInputs = [
      pkg-config
      makeWrapper
      pkgs.perl
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
      mkdir -p $out/build
      ln -s ${avante-nvim-lib}/lib/libavante_repo_map${ext} $out/build/avante_repo_map${ext}
      ln -s ${avante-nvim-lib}/lib/libavante_templates${ext} $out/build/avante_templates${ext}
      ln -s ${avante-nvim-lib}/lib/libavante_tokenizers${ext} $out/build/avante_tokenizers${ext}
      ln -s ${avante-nvim-lib}/lib/libavante_html2md${ext} $out/build/avante_html2md${ext}

      # Fixes PKCE auth flows not finding libcrypto
      substituteInPlace "$out/lua/avante/auth/pkce.lua" \
        --replace-fail 'pcall(ffi.load, "crypto")' 'pcall(ffi.load, "${lib.getLib openssl}/lib/libcrypto${ext}")'
    '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
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
    "avante.providers.ollama"
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
