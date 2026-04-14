{
  rustPlatform,
  fetchFromGitHub,
  lib,
  pkg-config,
  openssl,
  fontconfig,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emissary";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "altonen";
    repo = "emissary";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W4QEN52A6s1qDso73tM50/BcjxoX72LbmTG2kJiTfRs=";
  };
  cargoHash = "sha256-cP1ddtppcSUhl2G2C/Pd4+C/xqlB27/D12t5lFUfChQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    fontconfig
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/altonen/emissary/releases/tag/${finalAttrs.version}";
    description = "Rust implementation of the I2P protocol stack";
    homepage = "https://altonen.github.io/emissary/";
    license = lib.licenses.mit; # https://github.com/altonen/emissary/blob/master/LICENSE (found an apache2 as well but thats for https://github.com/altonen/emissary/commit/c4a1c849ebfceba892adce53f512f1f099721de2)
    mainProgram = "emissary-cli";
    maintainers = [ lib.maintainers.N4CH723HR3R ];
  };
})
