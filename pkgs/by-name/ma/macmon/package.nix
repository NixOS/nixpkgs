{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "macmon";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "vladkens";
    repo = "macmon";
    rev = "v${version}";
    hash = "sha256-COpEjK1LUwGzhSgD09D4gx+MtS2hT0qt06rTPT8JQiQ=";
  };

  cargoHash = "sha256-DTkpFGl8kTWttFGKTCpny2L0IRrCgpnnXaKIFoxWrW4=";

  meta = {
    homepage = "https://github.com/vladkens/macmon";
    description = "Sudoless performance monitoring for Apple Silicon processors";
    platforms = [ "aarch64-darwin" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ schrobingus ];
  };
}
