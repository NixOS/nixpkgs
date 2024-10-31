{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  vimUtils,
}:
let
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.cmp";
    rev = "refs/tags/v${version}";
    hash = "sha256-DmHMySR1K4j/z5+bZDJHIuqo5BqRP9XaOMEdCb78chk=";
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
        "frizbee-0.1.0" = "sha256-eYth+xOIqwGPkH39OxNCMA9zE+5CTNpsuX8Ue/mySIA=";
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
