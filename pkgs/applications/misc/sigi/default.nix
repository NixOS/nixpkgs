{ lib, rustPlatform, fetchCrate, installShellFiles, testVersion, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-wqdgrFeB3YuMo/r4ndqRZCz+M1WuUvX2pHHkyNMdnvo=";
  };

  cargoSha256 = "sha256-103zhlskzhEj6oUam7YDRWiSPTaV2PPJhzP7QeMBtDQ=";
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
