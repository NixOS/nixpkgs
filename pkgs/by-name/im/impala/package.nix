{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "impala";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${version}";
    hash = "sha256-FU/8g2zTTHm3Sdbxt9761Z+a0zaJMdAMdHrJIwjUrYs=";
  };

  cargoHash = "sha256-dpTLVlDxc9eK7GwbweODoJlrBZeYwVcv1fQ2UtYbg7k=";

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nydragon ];
  };
}
