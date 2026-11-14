{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libunwind
}:

rustPlatform.buildRustPackage {
  pname = "hermit";
  version = "0-unstable-2024-05-01";

  src = fetchFromGitHub {
    owner = "facebookexperimental";
    repo = "hermit";
    rev = "5ebb3fa4f54d9b09c877bd8e63bd169b2431b889";
    hash = "sha256-uzOczLGGSaAILwaDh0WKgs/JeMo3B6tOkNhEIhtBORQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fbinit-0.1.2" = "sha256-Z1C7aro540ZIPPVvnYHh2MzSZIYOGS3qHiN909SwrLA=";
      "reverie-0.1.0" = "sha256-ZXHkoRuwmv3ZTNYXtPJ7XU1p620tg9Lk7lsHQA2wzLE=";
    };
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  RUSTC_BOOTSTRAP=1;

  doCheck = false;

  buildInputs = [
    libunwind
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {

    description = "Launch x86_64 programs deterministically on specific CPUs that can control execution";
    longDescription = "Hermit launches linux x86_64 programs in a special, hermetically isolated sandbox to control their execution. Hermit translates normal, nondeterministic behavior, into deterministic, repeatable behavior. This can be used for various applications, including replay-debugging, reproducible artifacts, chaos mode concurrency testing and bug analysis";
    homepage = "https://github.com/facebookexperimental/hermit.git";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "hermit";
  };
}
