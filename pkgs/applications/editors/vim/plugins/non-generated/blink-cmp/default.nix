{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  stdenv,
  vimUtils,
  nix-update-script,
  git,
}:
let
  version = "0.13.1";
  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.cmp";
    tag = "v${version}";
    hash = "sha256-eOlTkWMzQTZPPKPKUxg8Q2PwkOhfaQdrMZkg9Ew8t/g=";
  };
  blink-fuzzy-lib = rustPlatform.buildRustPackage {
    inherit version src;
    pname = "blink-fuzzy-lib";

    useFetchCargoVendor = true;
    cargoHash = "sha256-F1wh/TjYoiIbDY3J/prVF367MKk3vwM7LqOpRobOs7I=";

    nativeBuildInputs = [ git ];

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
      echo -n "nix" > target/release/version
    '';

  # TODO: Remove this patch when updating to next version
  patches = [
    (fetchpatch {
      name = "blink-add-bypass-for-nix.patch";
      url = "https://github.com/Saghen/blink.cmp/commit/6c83ef1ae34abd7ef9a32bfcd9595ac77b61037c.diff?full_index=1";
      hash = "sha256-304F1gDDKVI1nXRvvQ0T1xBN+kHr3jdmwMMp8CNl+GU=";
    })
  ];

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

  nvimSkipModule = [
    # Module for reproducing issues
    "repro"
  ];
}
