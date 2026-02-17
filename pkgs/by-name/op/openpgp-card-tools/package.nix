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
  version = "0.11.10";

  src = fetchFromCodeberg {
    owner = "openpgp-card";
    repo = "openpgp-card-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1sm/zaKhUPMGdYg8sX/IXAI4vIRRZezSD89rljG4S/Y=";
  };

  cargoHash = "sha256-S+TOSUh/sr647aUBjo+aaZgVrrOubwa+XVFcwNBOxmI=";

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
