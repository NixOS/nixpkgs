{ lib, rustPlatform, fetchFromGitHub, testVersion, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "hiljusti";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-y0m1AQE5qoUfPZjJfo7w5h+zZ1pbz8FkLFDM13MTWvQ=";
  };

  cargoSha256 = "sha256-NTjL57Y1Uzk5F34BW3lB3xUpD60Opt0fGWuXHQU5L3g=";

  passthru.tests.version = testVersion { package = sigi; };

  meta = with lib; {
    description = "CLI tool for organization and planning";
    homepage = "https://github.com/hiljusti/sigi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hiljusti ];
  };
}
