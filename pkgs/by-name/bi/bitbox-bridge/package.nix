{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libudev-zero,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bitbox-bridge";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "BitBoxSwiss";
    repo = "bitbox-bridge";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-+pMXWXGHyyBx3N0kiro9NS0mPmSQzzBmp+pkoBLH7z0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6vD0XjGH1PXjiRjgnHWSZSixXOc2Yecui8U5FAGefBU=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libudev-zero
  ];

  meta = {
    description = "A bridge service that connects web wallets like Rabby to BitBox02";
    homepage = "https://github.com/BitBoxSwiss/bitbox-bridge";
    downloadPage = "https://bitbox.swiss/download/";
    changelog = "https://github.com/BitBoxSwiss/bitbox-bridge/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      izelnakri
      tensor5
    ];
    mainProgram = "bitbox-bridge";
    platforms = lib.platforms.unix;
  };
})
