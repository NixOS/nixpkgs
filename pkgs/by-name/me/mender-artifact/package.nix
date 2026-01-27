{
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  lib,
  openssl,
}:

buildGoModule rec {
  pname = "mender-artifact";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "mendersoftware";
    repo = "mender-artifact";
    rev = version;
    hash = "sha256-9VzVBMIurFDCRQBKLGOoRzOjnxNohllcBmmdCYszDxo=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  vendorHash = null;

  doCheck = false;

  meta = with lib; {
    homepage = "mender.io";
    description = "Library for managing Mender artifact files";
    mainProgram = "mender-artifact";
    license = licenses.asl20;
  };

}
