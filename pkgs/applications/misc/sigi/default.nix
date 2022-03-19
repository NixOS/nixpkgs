{ lib, rustPlatform, fetchCrate, installShellFiles, testVersion, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.0.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-tjhNE20GE1L8kvhdI5Mc90I75q8szOIV40vq2CBt98U=";
  };

  nativeBuildInputs = [ installShellFiles ];

  # As part of its tests, sigi hard-codes a location to BATS based on git
  # submodules. The tests are recommeded to skip for Linux packaging. They'll
  # move to Rust after this issue: https://github.com/hiljusti/sigi/issues/19
  checkFlags = [ "SKIP_BATS_TESTS=1" ];

  postInstall = ''
    installManPage sigi.1
  '';

  cargoSha256 = "sha256-0e0r6hfXGJmrc6tgCqq2dQXu2MhkThViZwdG3r3g028=";

  passthru.tests.version = testVersion { package = sigi; };

  meta = with lib; {
    description = "Organizing CLI for people who don't love organizing.";
    homepage = "https://github.com/hiljusti/sigi";
    license = licenses.gpl2;
    maintainers = with maintainers; [ hiljusti ];
  };
}
