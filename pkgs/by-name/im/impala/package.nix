{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "impala";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${version}";
    hash = "sha256-CRnGycN2juXXNI1LhAH5HQbmXYatBZ0GxYKYgb5SBSE=";
  };

  cargoHash = "sha256-fBeSbJdFwT/ZwK2FTJQtZakKqMiAICMY2rkbNnYOGzU=";

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nydragon ];
  };
}
