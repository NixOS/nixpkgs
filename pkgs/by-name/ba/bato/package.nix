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
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "doums";
    repo = "bato";
    rev = "v${version}";
    hash = "sha256-i2gw8vXiKutq26ACzkVXH3kED7jAngSv2mNo9P3qXnA=";
  };

  cargoHash = "sha256-bGbLQaYfNLem47iMPsNeKm4pP3+Pij9SJ3Nq5VWX3hE=";

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
