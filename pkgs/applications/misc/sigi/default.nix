{ lib, rustPlatform, fetchCrate, installShellFiles, testers, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.6.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-JGQ9UbkS3Q1ohy6vtiUlPijuffH4Gb99cZCKreGqE/U=";
  };

  cargoHash = "sha256-W/ekk4tsYxG7FXzJW5i0Ii7nLgDHCSCjO3couN+/sMk=";
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
