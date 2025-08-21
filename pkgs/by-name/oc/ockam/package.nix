{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
  nix-update-script,
  pkg-config,
  openssl,
  dbus,
}:

let
  pname = "ockam";
  version = "0.157.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "build-trust";
    repo = "ockam";
    rev = "ockam_v${version}";
    hash = "sha256-o895VPlUGmLUsIeOnShjCetKoS/4x0nbEKxipEbuBu4=";
  };

  cargoHash = "sha256-hHbMMi4nuTORUPEKEo3OiQg7y12+cXHzUAkh3ApYx5s=";
  nativeBuildInputs = [
    git
    pkg-config
  ];
  buildInputs = [
    openssl
    dbus
  ];

  passthru.updateScript = nix-update-script { };

  # too many tests fail for now
  doCheck = false;

  cargoBuildFlags = [ "-p ockam" ];

  meta = with lib; {
    description = "Orchestrate end-to-end encryption, cryptographic identities, mutual authentication, and authorization policies between distributed applications – at massive scale";
    homepage = "https://github.com/build-trust/ockam";
    license = licenses.mpl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
