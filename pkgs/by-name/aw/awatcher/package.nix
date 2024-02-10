{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, gnomeSupport ? true
, kwinSupport ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "awatcher";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "2e3s";
    repo = "awatcher";
    rev = "v${version}";
    hash = "sha256-e65QDbK55q1Pbv/i7bDYRY78jgEUD1q6TLdKD8Gkswk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ ]
    ++ lib.optional gnomeSupport "gnome"
    ++ lib.optional kwinSupport "kwin_window";

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
