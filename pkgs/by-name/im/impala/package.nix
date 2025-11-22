{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "impala";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${version}";
    hash = "sha256-sLEOMk6WlqEyvho48asd5htvxXRAtSLEvqVjT1Zqmhs=";
  };

  cargoHash = "sha256-FfkAyNXF2c0pLpBWi78bS+N8EjgoAxbAixMwYXK9RZ8=";

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nydragon ];
  };
}
