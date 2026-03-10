{
  lib,
  stdenv,
  rustPlatform,
  fetchFromCodeberg,
  installShellFiles,
  pkg-config,
  pcsclite,
  dbus,
  testers,
  openpgp-card-tools,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openpgp-card-tools";
  version = "0.11.11";

  src = fetchFromCodeberg {
    owner = "openpgp-card";
    repo = "openpgp-card-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4kmBWbfB9A36359zhR5fz0XFcN839gTtJFRFhJL1lL0=";
  };

  cargoHash = "sha256-kXBPDwHkoB/W2sSIjChf4VnoNykvIKSSIv8YsW3iu1Y=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    pcsclite
    dbus
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = openpgp-card-tools;
    };
  };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    OCT_COMPLETION_OUTPUT_DIR=$PWD/shell $out/bin/oct
    installShellCompletion ./shell/oct.{bash,fish} ./shell/_oct
    OCT_MANPAGE_OUTPUT_DIR=$PWD/man $out/bin/oct
    installManPage ./man/*.1
  '';

  meta = {
    description = "Tool for inspecting and configuring OpenPGP cards";
    homepage = "https://codeberg.org/openpgp-card/openpgp-card-tools";
    license = with lib.licenses; [
      asl20 # OR
      mit
    ];
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "oct";
  };
})
