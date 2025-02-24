{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "cntr";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "cntr";
    rev = version;
    sha256 = "sha256-2tqPxbi8sKoEPq0/zQFsOrStEmQGlU8s81ohTfKeOmE=";
  };

  cargoHash = "sha256-CPF3WO8y9AL8VvsnUbnXiPgHu103lBugnPN2+fxRl2k=";

  passthru.tests = nixosTests.cntr;

  meta = with lib; {
    description = "Container debugging tool based on FUSE";
    homepage = "https://github.com/Mic92/cntr";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      mic92
      sigmasquadron
    ];
    mainProgram = "cntr";
  };
}
