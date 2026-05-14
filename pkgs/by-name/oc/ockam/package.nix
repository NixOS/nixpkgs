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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ockam";
  version = "0.157.0";

  src = fetchFromGitHub {
    owner = "build-trust";
    repo = "ockam";
    rev = "ockam_v${finalAttrs.version}";
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

  meta = {
    description = "Orchestrate end-to-end encryption, cryptographic identities, mutual authentication, and authorization policies between distributed applications – at massive scale";
    homepage = "https://github.com/build-trust/ockam";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
