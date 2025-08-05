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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.pairs";
    tag = "v${version}";
    hash = "sha256-RTY/uGviyHlO+ZmLwOC5BabKr+kRDAXGZNdS9fVRPWA=";
  };

  blink-pairs-lib = rustPlatform.buildRustPackage {
    pname = "blink-pairs";
    inherit version src;

    cargoHash = "sha256-j+zk0UMjvaVgsdF5iaRVO4Puf/XtGu08Cs92jKPaM1g=";

    env.RUSTC_BOOTSTRAP = 1;

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
