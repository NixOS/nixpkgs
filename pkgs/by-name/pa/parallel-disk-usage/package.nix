{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "parallel-disk-usage";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = pname;
    rev = version;
    hash = "sha256-2w+A2ZpmLPBSj9odGh8QWAadE6e2XPJmBZwl6ZT6bSc=";
  };

  cargoHash = "sha256-WwWNAF0iKFZJ8anvXUJwXo8xw5pCNVO7RcAMyA1R4wE=";

  meta = with lib; {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = licenses.asl20;
    maintainers = [maintainers.peret];
    mainProgram = "pdu";
  };
}
