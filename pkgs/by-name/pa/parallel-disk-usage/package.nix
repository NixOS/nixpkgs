{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "parallel-disk-usage";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = pname;
    rev = version;
    hash = "sha256-0SK7v5xKMPuukyYKaGk13PE3WygHginjnyoatkA5xFQ=";
  };

  cargoHash = "sha256-T/TjiqBZJINgiuTLWD+JBCUDEQBs2b/hvZn9E2uxkYc=";

  meta = {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.peret ];
    mainProgram = "pdu";
  };
}
