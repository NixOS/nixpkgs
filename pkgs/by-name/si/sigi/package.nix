{ lib, rustPlatform, fetchCrate, installShellFiles, testers, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.6.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-hw4dLQlIftbQfUK9+MT29jPPaeOPVLfkR6nqxJkn+t0=";
  };

  cargoHash = "sha256-WS+75LeXBuw6P1PZpygVrWbEHOuQCCzM9hsmkLwHsIg=";
  nativeBuildInputs = [ installShellFiles ];

  # In case anything goes wrong.
  checkFlags = [ "RUST_BACKTRACE=1" ];

  postInstall = ''
    installManPage sigi.1
  '';

  passthru.tests.version = testers.testVersion { package = sigi; };

  meta = with lib; {
    description = "Organizing CLI for people who don't love organizing.";
    homepage = "https://github.com/sigi-cli/sigi";
    license = licenses.gpl2;
    maintainers = with maintainers; [ booniepepper ];
    mainProgram = "sigi";
  };
}
