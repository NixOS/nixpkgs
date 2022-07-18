{ lib, rustPlatform, fetchCrate, installShellFiles, testers, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.4.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-YlTawz09i7k5QxaybKSo4IhECs6UdDSNV+ylIJgKPt4=";
  };

  cargoSha256 = "sha256-L4eIGxQTM+sZWXWZDGtSwsCT54CWLbyPQ9b+Jf6s94U=";
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
