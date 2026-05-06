{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenv,
  pkg-config,
  openssl,
  fontconfig,
  libx11,
  libxkbcommon,
  wayland,
  makeWrapper,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emissary";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "eepnet";
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

  postFixup = lib.optionalString stdenv.targetPlatform.isLinux ''
    patchelf $out/bin/${finalAttrs.meta.mainProgram} \
      --add-rpath ${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
          libx11
        ]
      }
  '';

  meta = {
    changelog = "https://github.com/eepnet/emissary/releases/tag/${finalAttrs.version}";
    description = "Rust implementation of the I2P protocol stack";
    homepage = "https://eepnet.github.io/emissary/";
    license = lib.licenses.mit; # https://github.com/eepnet/emissary/blob/master/LICENSE (found an apache2 as well but thats for https://github.com/eepnet/emissary/commit/c4a1c849ebfceba892adce53f512f1f099721de2)
    mainProgram = "emissary-cli";
    maintainers = [
      lib.maintainers.N4CH723HR3R
      lib.maintainers.cappuccinocosmico
    ];
  };
})
