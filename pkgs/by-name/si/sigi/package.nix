{ lib, rustPlatform, fetchCrate, installShellFiles, testers, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-rDVuI+sY7yG9Tni5/klnWM1KHg7iZuPQXFnLz96B0L4=";
  };

  cargoHash = "sha256-QqAcK75BDIWlYggkZkokZ/C1SxCFviZ0t+h1q+dM8I4=";
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
