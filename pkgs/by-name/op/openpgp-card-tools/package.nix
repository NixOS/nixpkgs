{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitea,
  installShellFiles,
  pkg-config,
  pcsclite,
  dbus,
  testers,
  openpgp-card-tools,
}:

rustPlatform.buildRustPackage rec {
  pname = "openpgp-card-tools";
  version = "0.11.9";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "openpgp-card";
    repo = "openpgp-card-tools";
    rev = "v${version}";
    hash = "sha256-kT/egkOBOomUX+fwT3OeRSZOnGeuFRLKKAXtW8nN4rw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mZZ8veY3iqsgScfFAGYo496qxTew24R5NxYf3WjnHco=";

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

  meta = with lib; {
    description = "Tool for inspecting and configuring OpenPGP cards";
    homepage = "https://codeberg.org/openpgp-card/openpgp-card-tools";
    license = with licenses; [
      asl20 # OR
      mit
    ];
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "oct";
  };
}
