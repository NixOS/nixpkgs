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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.pairs";
    tag = "v${version}";
    hash = "sha256-fOOo+UnrbQJFWyqjpiFwhytlPoPRnUlGswQdZb3/ws0=";
  };

  blink-pairs-lib = rustPlatform.buildRustPackage {
    pname = "blink-pairs";
    inherit version src;

    useFetchCargoVendor = true;
    cargoHash = "sha256-vkybRuym1yibaw943Gs9luYLdYEp4tgvA8e4maATiTY=";

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
