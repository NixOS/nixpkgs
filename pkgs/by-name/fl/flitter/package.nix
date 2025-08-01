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
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "alexozer";
    repo = "flitter";
    tag = version;
    hash = "sha256-LG4gCpV4NUOuQMjGIjjX+pc9dL/IG6pzy3J5cDfUE5k=";
  };

  cargoHash = "sha256-V+GsBEyGNI+13TsIci5GC0VW5BYPCGDAlpaj9DQWjCg=";

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
