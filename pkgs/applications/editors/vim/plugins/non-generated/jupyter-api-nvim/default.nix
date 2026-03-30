{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  vimUtils,
  nix-update-script,
  gitMinimal,
}:
let
  version = "0-unstable-2026-01-10";
  src = fetchFromGitHub {
    owner = "bitbloxhub";
    repo = "jupyter-api.nvim";
    rev = "5dd157fd8cd9ef6d20075c0809f54c9f7af23e43";
    hash = "sha256-N9Z7SaWeT8b2N3EtwwRLW7DCiQk0+tCd9e573DSq7SQ=";
  };
  jupyter-api-nvim-lib = rustPlatform.buildRustPackage {
    inherit version src;
    pname = "jupyter-api-nvim-lib";

    cargoHash = "sha256-Oe6NnnNBY2nzYkNYucPpR6iV/8a6/9ZUytKpdHWY+So=";

    env = {
      # Allow undefined symbols on Darwin - they will be provided by Neovim's LuaJIT runtime
      RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-C link-arg=-undefined -C link-arg=dynamic_lookup";
    };
  };
in
vimUtils.buildVimPlugin {
  pname = "jupyter-api.nvim";
  inherit version src;
  preInstall =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir -p target/release
      ln -s ${jupyter-api-nvim-lib}/lib/libjupyter_api_nvim${ext} target/release/libjupyter_api_nvim${ext}
    '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.jupyter-api-nvim.jupyter-api-nvim-lib";
    };

    # needed for the update script
    inherit jupyter-api-nvim-lib;
  };

  meta = {
    description = "Library for interacting with Jupyter kernels from Neovim Lua";
    homepage = "https://github.com/bitbloxhub/jupyter-api.nvim/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      bitbloxhub
    ];
  };
}
