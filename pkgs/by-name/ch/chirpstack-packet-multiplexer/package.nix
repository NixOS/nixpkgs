{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-packet-multiplexer";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-packet-multiplexer";
    tag = "v${version}";
    hash = "sha256-BMlfYYt3fS3bOZulLqT9QRIZS0T4r/u9Y2VnQdI0oF0=";
  };

  cargoHash = "sha256-8HyIrViGKVldlA66k1fz+iHJ+ZdsGi1AqGQtxo8WLFQ=";

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
