{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  vimUtils,
  stdenv,
  nix-update-script,
}:
let
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.pairs";
    tag = "v${version}";
    hash = "sha256-IfnFSusQMm6LujE1AmihK9wEF2RSGfKYwpV2fedg0fc=";
  };

  blink-pairs-lib = rustPlatform.buildRustPackage {
    pname = "blink-pairs";
    inherit version src;

    cargoHash = "sha256-Cn9zRsQkBwaKbBD/JEpFMBOF6CBZTDx7fQa6Aoic4YU=";

    env = {
      RUSTC_BOOTSTRAP = 1;

      # Allow undefined symbols on Darwin - they will be provided by Neovim's LuaJIT runtime
      RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-C link-arg=-undefined -C link-arg=dynamic_lookup";
    };

    # NOTE: Disabled upstream too
    doCheck = false;

    nativeBuildInputs = [
      pkg-config
    ];
  };
in
vimUtils.buildVimPlugin {
  pname = "blink.pairs";
  inherit version src;

  preInstall =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir -p target/release
      ln -s ${blink-pairs-lib}/lib/libblink_pairs${ext} target/release/
    '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.blink-pairs.blink-pairs-lib";
    };

    # needed for the update script
    inherit blink-pairs-lib;
  };

  meta = {
    description = "Rainbow highlighting and intelligent auto-pairs for Neovim";
    homepage = "https://github.com/Saghen/blink.pairs";
    changelog = "https://github.com/Saghen/blink.pairs/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
