{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rs-tftpd";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    rev = version;
    hash = "sha256-RUjxCHO4X3V3Mt6zargqqT2v92XTt8FO9S68+tYZFC0=";
  };

  cargoHash = "sha256-sLdOVthIHXzdY0/tVn2J0CUr3IqLsVHO/5S4X0NmN64=";

  buildFeatures = [ "client" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "tftpd";
  };
}
