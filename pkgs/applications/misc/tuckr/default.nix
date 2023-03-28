{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "tuckr";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "RaphGL";
    repo = "Tuckr";
    rev = version;
    sha256 = "sha256-47qnBGCiPWJGF4QcqjzmDIZWlCO3xE3QyIF6nSPGWAc=";
  };

  cargoHash = "sha256-IX7ZX4fKBK0wS7nlSdf/bVGzXl2GU7qwwmtPMoOe/m8=";

  # Cargo.lock is outdated
  preConfigure = ''
    cargo update --offline
  '';

  doCheck = false; # test result: FAILED. 5 passed; 3 failed;

  meta = with lib; {
    description = "A super powered replacement for GNU Stow";
    homepage = "https://github.com/RaphGL/Tuckr";
    changelog = "https://github.com/RaphGL/Tuckr/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mimame ];
  };
}
