{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rs-tftpd";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    rev = version;
    hash = "sha256-ZWafSqHEBgS7LR9hTfatatvAFZnCP8L5rHLerdjyrUc=";
  };

  cargoHash = "sha256-uBVDH7YYSuFv0r5T2+EAoL02ta+1hjaza/Ilu+a+k0k=";

  buildFeatures = [ "client" ];

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "tftpd";
  };
}
