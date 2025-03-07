{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libudev-zero,
}:

rustPlatform.buildRustPackage rec {
  pname = "bitbox-bridge";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "BitBoxSwiss";
    repo = "bitbox-bridge";
    tag = "v${version}";
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
    description = "Bridge service that connects web wallets like Rabby to BitBox02";
    homepage = "https://github.com/BitBoxSwiss/bitbox-bridge";
    downloadPage = "https://bitbox.swiss/download/";
    changelog = "https://github.com/BitBoxSwiss/bitbox-bridge/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      izelnakri
      tensor5
    ];
    mainProgram = "bitbox-bridge";
  };
}
