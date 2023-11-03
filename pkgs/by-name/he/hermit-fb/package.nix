{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libunwind
}:

rustPlatform.buildRustPackage rec {
  pname = "hermit";
  version = "unstable-2023-10-21";

  src = fetchFromGitHub {
    owner = "facebookexperimental";
    repo = "hermit";
    rev = "776258a963f037335c8067fc67e35366d98d1d78";
    hash = "sha256-mIdTeFeYzaEO/fUF5zzW3Q5MNz/WMIynBBPcWUAh5vk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fbinit-0.1.2" = "sha256-Mp7zcgtZhLDMGeP4qwXkR9uW5eH8UEBWSKCQx6vzrl0=";
      "reverie-0.1.0" = "sha256-+4vnK2M6vIcJ+KW/CPvlYGzieZ4eoxXvdRtLzDH+KXc=";
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
    description = "Hermit launches linux x86_64 programs in a special, hermetically isolated sandbox to control their execution. Hermit translates normal, nondeterministic behavior, into deterministic, repeatable behavior. This can be used for various applications, including replay-debugging, reproducible artifacts, chaos mode concurrency testing and bug analysis";
    homepage = "https://github.com/facebookexperimental/hermit.git";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "hermit";
  };
}
