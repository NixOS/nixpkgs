{ lib, rustPlatform, fetchCrate, installShellFiles, testers, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.6.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-VhBrSepJdwJRu+AqXWUzdDO4ukJPeoZr07B/X8Jr/RA=";
  };

  cargoSha256 = "sha256-R1U0ZYQMA1VFd5zEjFzl5QhwqqEMaCFb/5H509IBj60=";
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
    maintainers = with maintainers; [ hiljusti ];
  };
}
