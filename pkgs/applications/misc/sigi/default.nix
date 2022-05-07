{ lib, rustPlatform, fetchCrate, installShellFiles, testVersion, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.3.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-dcfzCac4dT2X1hgTSh30G7h2XtvVj1jMUmrUzqZ11y8=";
  };

  cargoSha256 = "sha256-CQofC9Y0y8XASLpjk9B6mMlSQqiXnoGZ8kJh16txiPA=";
  nativeBuildInputs = [ installShellFiles ];

  # In case anything goes wrong.
  checkFlags = [ "RUST_BACKTRACE=1" ];

  postInstall = ''
    installManPage sigi.1
  '';

  passthru.tests.version = testVersion { package = sigi; };

  meta = with lib; {
    description = "Organizing CLI for people who don't love organizing.";
    homepage = "https://github.com/hiljusti/sigi";
    license = licenses.gpl2;
    maintainers = with maintainers; [ hiljusti ];
  };
}
