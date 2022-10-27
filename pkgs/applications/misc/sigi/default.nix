{ lib, rustPlatform, fetchCrate, installShellFiles, testers, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.4.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-CDu/tllCwmt+UO4ae1uFkR4KKCWdxM4aW1O7oY59qHE=";
  };

  cargoSha256 = "sha256-pMOaw7Ra78aRisYF9ttbpjB/cbylpzZXw8DtBqn5Tjo=";
  nativeBuildInputs = [ installShellFiles ];

  # In case anything goes wrong.
  checkFlags = [ "RUST_BACKTRACE=1" ];

  postInstall = ''
    installManPage sigi.1
  '';

  passthru.tests.version = testers.testVersion { package = sigi; };

  meta = with lib; {
    description = "Organizing CLI for people who don't love organizing.";
    homepage = "https://github.com/hiljusti/sigi";
    license = licenses.gpl2;
    maintainers = with maintainers; [ hiljusti ];
  };
}
