{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  vimUtils,
}:
let
  version = "0.3.1";
  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.cmp";
    rev = "refs/tags/v${version}";
    hash = "sha256-bvhLOM0NMx5S069uX2OecEpzYaR3hV4r8nCIPD0f0XQ=";
  };
  libExt = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
  blink-fuzzy-lib = rustPlatform.buildRustPackage {
    inherit version src;
    pname = "blink-fuzzy-lib";
    env = {
      # TODO: remove this if plugin stops using nightly rust
      RUSTC_BOOTSTRAP = true;
    };
    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "c-marshalling-0.2.0" = "sha256-eL6nkZOtuLLQ0r31X7uroUUDYZsWOJ9KNXl4NCVNRuw=";
        "frizbee-0.1.0" = "sha256-zO2S282DVCjnALMXu3GxmAfjCXsPNUZ7+xgiqITfGmU=";
      };
    };
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
