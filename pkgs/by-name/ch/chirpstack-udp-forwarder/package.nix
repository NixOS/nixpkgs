{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  protobuf,
}:
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-udp-forwarder";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-udp-forwarder";
    rev = "v${version}";
    hash = "sha256-BCflOG9v+tW5o0b/hZqlcg1BA+V/lpNzr3fJ9eg6qeY=";
  };

  cargoHash = "sha256-2XTb9Wv61as7XhNMjJeryVq8nY835AxiONJjapdgCAw=";

  nativeBuildInputs = [ protobuf ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "UDP packet-forwarder for the ChirpStack Concentratord";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-udp-forwarder";
  };
}
