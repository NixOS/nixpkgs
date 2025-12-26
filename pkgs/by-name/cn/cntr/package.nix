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

  cargoHash = "sha256-gWQ8seCuUSHuZUoNH9pnBTlzF9S0tHVLStnAiymLLbs=";

  passthru.tests = nixosTests.cntr;

  meta = {
    description = "Container debugging tool based on FUSE";
    homepage = "https://github.com/Mic92/cntr";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mic92
      sigmasquadron
    ];
    mainProgram = "cntr";
  };
}
