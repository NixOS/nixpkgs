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
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.cmp";
    tag = "v${version}";
    hash = "sha256-0e1XZTbdHUCwhzw9gDFDsN67jX/jqcHTIyPYyJx/shI=";
  };
  blink-fuzzy-lib = rustPlatform.buildRustPackage {
    inherit version src;
    pname = "blink-fuzzy-lib";

    useFetchCargoVendor = true;
    cargoHash = "sha256-F1wh/TjYoiIbDY3J/prVF367MKk3vwM7LqOpRobOs7I=";

    nativeBuildInputs = [ gitMinimal ];

    env = {
      # TODO: remove this if plugin stops using nightly rust
      RUSTC_BOOTSTRAP = true;
    };
  };
in
vimUtils.buildVimPlugin {
  pname = "blink.cmp";
  inherit version src;
  preInstall =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir -p target/release
      ln -s ${blink-fuzzy-lib}/lib/libblink_cmp_fuzzy${ext} target/release/libblink_cmp_fuzzy${ext}
    '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.blink-cmp.blink-fuzzy-lib";
    };

    # needed for the update script
    inherit blink-fuzzy-lib;
  };

  meta = {
    description = "Performant, batteries-included completion plugin for Neovim";
    homepage = "https://github.com/saghen/blink.cmp";
    changelog = "https://github.com/Saghen/blink.cmp/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      balssh
      redxtech
    ];
  };

  nvimSkipModules = [
    # Module for reproducing issues
    "repro"
  ];
}
