{ lib, rustPlatform, fetchCrate, installShellFiles, testVersion, sigi }:

rustPlatform.buildRustPackage rec {
  pname = "sigi";
  version = "3.0.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1xZMj6NjwA9pVOEL4CDv4XHC3usu3WdjsLJuW3vgxc8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage sigi.1
  '';

  cargoSha256 = "sha256-NUWm2GkK7bASo6bAOgQgHate45iDG5l3G/KhtLrjzQ8=";

  passthru.tests.version = testVersion { package = sigi; };

  meta = with lib; {
    description = "CLI tool for organization and planning";
    homepage = "https://github.com/hiljusti/sigi";
    license = licenses.gpl2;
    maintainers = with maintainers; [ hiljusti ];
  };
}
