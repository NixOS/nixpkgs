{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  vimUtils,
}:
let
  version = "0.6.2";
  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.cmp";
    rev = "refs/tags/v${version}";
    hash = "sha256-uAIO8Q9jQvZ36Ngz9dURH7Jo7+WX/swauhj3ltIkZ5c=";
  };
  libExt = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
  blink-fuzzy-lib = rustPlatform.buildRustPackage {
    inherit version src;
    pname = "blink-fuzzy-lib";
    env = {
      # TODO: remove this if plugin stops using nightly rust
      RUSTC_BOOTSTRAP = true;
    };
    useFetchCargoVendor = true;
    cargoHash = "sha256-XXI2jEoD6XbFNk3O8B6+aLzl1ZcJq1VinQXb+AOw8Rw=";
  };
in
vimUtils.buildVimPlugin {
  pname = "blink-cmp";
  inherit version src;
  preInstall = ''
    mkdir -p target/release
    ln -s ${blink-fuzzy-lib}/lib/libblink_cmp_fuzzy.${libExt} target/release/libblink_cmp_fuzzy.${libExt}
  '';
  meta = {
    description = "Performant, batteries-included completion plugin for Neovim";
    homepage = "https://github.com/saghen/blink.cmp";
    maintainers = with lib.maintainers; [
      balssh
      redxtech
    ];
  };
  doInstallCheck = true;
  nvimRequireCheck = "blink-cmp";
}
