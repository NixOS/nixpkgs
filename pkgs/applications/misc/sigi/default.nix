{ lib, rustPlatform, fetchCrate, installShellFiles, testVersion, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.0.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-N+8DdokiYW5mHIQJisdTja8xMVGip37X6c/xBYnQaRU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  # As part of its tests, sigi hard-codes a location to BATS based on git
  # submodules. The tests are recommeded to skip for Linux packaging. They'll
  # move to Rust after this issue: https://github.com/hiljusti/sigi/issues/19
  checkFlags = [ "SKIP_BATS_TESTS=1" ];

  postInstall = ''
    installManPage sigi.1
  '';

  cargoSha256 = "sha256-vO9ocTDcGt/T/sLCP+tCHXihV1H2liFDjI7OhhmPd3I=";

  passthru.tests.version = testVersion { package = sigi; };

  meta = with lib; {
    description = "Organizing CLI for people who don't love organizing.";
    homepage = "https://github.com/hiljusti/sigi";
    license = licenses.gpl2;
    maintainers = with maintainers; [ hiljusti ];
  };
}
