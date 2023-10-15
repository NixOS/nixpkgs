{ lib, rustPlatform, fetchCrate, installShellFiles, testers, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.6.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-vuAtTygRIUJG+gtBF3hA9HxlzJ06vPkvkaolzcZ7IT8=";
  };

  cargoSha256 = "sha256-uD8rOxWVMes/nhGN2DApoCklv5w9ab8S4jOnMg1k4KM=";
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
  };
}
