{ lib, rustPlatform, fetchCrate, installShellFiles, testers, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.6.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-UL4V/5XvqaqO4R2ievw379D/rzHf/ITgvG3BcSbMeTQ=";
  };

  cargoSha256 = "sha256-wzTUK4AvJmBK7LX7CLCAeAXLDxMJA/3qs/KT1+pMaoI=";
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
