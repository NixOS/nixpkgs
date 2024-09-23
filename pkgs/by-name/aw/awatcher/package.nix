{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "awatcher";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "2e3s";
    repo = "awatcher";
    rev = "v${version}";
    hash = "sha256-G7UH2JcKseGZUA+Ac431cTXUP7rxWxYABfq05/ENjUM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  doCheck = false;

  cargoLock = {
    lockFile = ./Cargo.lock;

    outputHashes = {
      "aw-client-rust-0.1.0" = "sha256-yliRLPM33GWTPcNBDNuKMOkNOMNfD+TI5nRkh+5YSnw=";
    };
  };

  meta = with lib; {
    description = "Activity and idle watchers";
    longDescription = ''
      Awatcher is a window activity and idle watcher with an optional tray and UI for statistics. The goal is to compensate
      the fragmentation of desktop environments on Linux by supporting all reportable environments, to add more
      flexibility to reports with filters, and to have better UX with the distribution by a single executable.
    '';
    downloadPage = "https://github.com/2e3s/awatcher/releases";
    homepage = "https://github.com/2e3s/awatcher";
    license = licenses.mpl20;
    mainProgram = "awatcher";
    maintainers = [ maintainers.aikooo7 ];
    platforms = platforms.linux;
  };
}
