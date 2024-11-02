{
  lib,
  fetchFromGitLab,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "peertube-viewer";
  version = "1.8.6";

  src = fetchFromGitLab {
    owner = "peertube-viewer";
    repo = "peertube-viewer-rs";
    rev = "v1.8.6";
    hash = "sha256-ZzeWk01migUrKR7GndtNo0kLYSCUXCg0H0eCXgrDXaM==";
  };

  cargoHash = "sha256-5u5240PL5cKhnHsT7sRdccrbZBAbRN+fa+FhJP1gX/4==";

  meta = with lib; {
    description = "A simple CLI browser for the peertube federated video platform";
    homepage = "https://gitlab.com/peertube-viewer/peertube-viewer-rs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ haruki7049 ];
  };
}
