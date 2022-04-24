{ lib, rustPlatform, fetchCrate, installShellFiles, testers, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.2.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1eZ6i0CvjNyYlWb7c0OPlGtvVSFpi8hiOl/7qeeE9wA=";
  };

  cargoSha256 = "sha256-Tyrcu/BYt9k4igiEIiZ2I7VIGiBZ3D2i6XfT/XGlU+U=";
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
