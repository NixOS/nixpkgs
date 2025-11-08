{
  lib,
  fetchFromGitLab,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "peertube-viewer";
  version = "1.8.6";

  src = fetchFromGitLab {
    owner = "peertube-viewer";
    repo = "peertube-viewer-rs";
    rev = "v1.8.6";
    hash = "sha256-ZzeWk01migUrKR7GndtNo0kLYSCUXCg0H0eCXgrDXaM==";
  };

  cargoHash = "sha256-Pf8Jj8XGYbNOAyYEBdAysOK92S3S7bZHerQh/2UlrbQ=";

  meta = with lib; {
    description = "Simple CLI browser for the peertube federated video platform";
    homepage = "https://gitlab.com/peertube-viewer/peertube-viewer-rs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ haruki7049 ];
    mainProgram = "peertube-viewer-rs";
  };
}
