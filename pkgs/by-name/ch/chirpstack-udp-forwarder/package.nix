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
  version = "4.1.10";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-udp-forwarder";
    rev = "v${version}";
    hash = "sha256-71pzD1wF6oNgi2eP/f/buX/vWpZda5DpD2mN1F7n3lk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3RrFA/THO9fWfk41nVbFGFv/VeFOcdN2mWgshC5PODw=";

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
