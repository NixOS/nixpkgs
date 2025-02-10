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

  useFetchCargoVendor = true;
  cargoHash = "sha256-nhFTXjOXy9QxsASlZHC4jXAJ/Xw65g1l3JczOYvq3dc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    xorg.libX11
  ];

  meta = with lib; {
    description = "Livesplit-inspired speedrunning split timer for Linux/macOS terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    homepage = "https://github.com/alexozer/flitter";
    platforms = platforms.unix;
    mainProgram = "flitter";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
