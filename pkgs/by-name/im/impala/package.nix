{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "impala";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${version}";
    hash = "sha256-0ULcknkZKYEvuqlcY8E1kZtpA0lPxxjRV2/zfak+FKU=";
  };

  cargoHash = "sha256-1jFUfpinqXBu8eTFAA1dRDk1F1IhNjcA7CkJmaIjkFQ=";

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nydragon ];
  };
}
