{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libudev-zero,
  nixosTests,
  nix-update-script,
  udevCheckHook,
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

  cargoHash = "sha256-6vD0XjGH1PXjiRjgnHWSZSixXOc2Yecui8U5FAGefBU=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libudev-zero
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/lib/systemd/user
    substitute bitbox-bridge/release/linux/bitbox-bridge.service $out/lib/systemd/user/bitbox-bridge.service \
      --replace-fail /opt/bitbox-bridge/bin/bitbox-bridge $out/bin/bitbox-bridge
    install -Dm644 bitbox-bridge/release/linux/hid-digitalbitbox.rules $out/etc/udev/rules.d/50-hid-digitalbitbox.rules
  '';

  doInstallCheck = true;

  passthru = {
    tests.basic = nixosTests.bitbox-bridge;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Bridge service that connects web wallets like Rabby to BitBox02";
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
