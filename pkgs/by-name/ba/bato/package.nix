{
  lib,
  pkg-config,
  cmake,
  libnotify,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "bato";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "doums";
    repo = "bato";
    rev = "v${version}";
    hash = "sha256-pq+i4NGl7yv+vmMoYVT9JRvOsuV7nBqXpsebgMcNEY0=";
  };

  cargoHash = "sha256-ZVzIoq+s2Xw996NoQMIGHUqo2uXJMu9lXfY5Us9NMPg=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [ libnotify ];

  meta = {
    description = "Small program to send battery notifications";
    homepage = "https://github.com/doums/bato";
    changelog = "https://github.com/doums/bato/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ HaskellHegemonie ];
    platforms = lib.platforms.linux;
    mainProgram = "bato";
  };
}
