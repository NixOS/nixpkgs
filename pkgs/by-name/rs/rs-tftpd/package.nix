{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rs-tftpd";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    rev = version;
    hash = "sha256-iUoIBQTMC+oXsuZcnSp1K4uFuETKTcfaW6+fBa5PQw8=";
  };

  cargoHash = "sha256-ZED5+WnOALLXAW/l/QMFKWco6kJnz4rFv8nfp00HS78=";

  buildFeatures = [ "client" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    license = licenses.mit;
    maintainers = with maintainers; [
      adamcstephens
      matthewcroughan
    ];
    mainProgram = "tftpd";
  };
}
