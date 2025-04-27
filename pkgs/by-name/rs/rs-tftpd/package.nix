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

  useFetchCargoVendor = true;
  cargoHash = "sha256-xnvruSfrd2RWgWjV+mqMciGY/L2ynJrYW/j+P6rphEs=";

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
