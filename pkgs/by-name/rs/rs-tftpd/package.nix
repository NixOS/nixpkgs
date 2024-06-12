{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rs-tftpd";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    rev = version;
    hash = "sha256-ABxgptbdepyTqMOz1YHSNRn1+8xYo8vN/dqZiSleJz4=";
  };

  cargoHash = "sha256-8QVgdQnis0ihkU5ZYtxbPIM+9arfO4do1ToRHoi94A8=";

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "tftpd";
  };
}
