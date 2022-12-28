{ lib, rustPlatform, fetchCrate, installShellFiles, testers, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.5.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-VUf5fCVOZCn0iY51eBS/fIvlxQF+BY+k75I+NY7yqzM=";
  };

  cargoSha256 = "sha256-ivSVcpUDGK0dJDy+jY7BYQIFCXu/npV0MiNe3nlsUho=";
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
