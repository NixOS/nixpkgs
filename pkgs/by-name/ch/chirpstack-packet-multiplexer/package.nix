{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-packet-multiplexer";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-packet-multiplexer";
    tag = "v${version}";
    hash = "sha256-GZygrejsenunkPlvejbi0MEIw226hrcbEYoBCRPQXMM=";
  };

  cargoHash = "sha256-DUPhgDfJQ6BhhgiBhYr6qtO8hjB1KcOXlFSbvjo1PHk=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "orward Semtech packet-forwarder data to multiple servers";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-packet-multiplexer";
  };
}
