{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rs-tftpd";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    rev = version;
    hash = "sha256-J7Cy8ymqZH1dCQ4/NWi+ukOsD/0KAfqgYBnCgfRt/KU=";
  };

  cargoHash = "sha256-gVNwMgv3acJaoQFJi5G/zo2ECzxYvcgaHlpwuCF2HVE=";

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "tftpd";
  };
}
