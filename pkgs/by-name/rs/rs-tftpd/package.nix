{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rs-tftpd";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    rev = version;
    hash = "sha256-qazPEzLMIlnqKTayurZgNJ8TLLdB4qNO88tKMoh6VVI=";
  };

  cargoHash = "sha256-4OVP3W5Packi5KcIqbDFpNQ2DXaAEPZTZ8pqABVLByQ=";

  buildFeatures = [ "client" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "tftpd";
  };
}
