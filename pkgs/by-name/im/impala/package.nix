{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "impala";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${version}";
    hash = "sha256-E3Vb2ZgpU0Qj5IoyB1zCyhUD1Cz07TVV0B2M6IFZ6KQ=";
  };

  cargoHash = "sha256-vRhv3hu6GsyOJZdP+zMFHnlNa3ETksSp6p18nVUUMQc=";

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nydragon ];
  };
}
