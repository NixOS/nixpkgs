{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "flitter";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "alexozer";
    repo = "flitter";
    rev = "v${version}";
    sha256 = "sha256-8e13kSQEjzzf+j4uTrocVioZjJ6lAz+80dLfWwjPb9o=";
  };

  cargoHash = "sha256-NpUSWoOUhSgbzeCkXEgn4P387bada6fv/M8aZYe8CoU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    xorg.libX11
  ];

  meta = {
    description = "Livesplit-inspired speedrunning split timer for Linux/macOS terminal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
    homepage = "https://github.com/alexozer/flitter";
    platforms = lib.platforms.unix;
    mainProgram = "flitter";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
