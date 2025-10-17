{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage {
  pname = "lunatic";
  version = "0.13.2-unstable-2025-03-29";

  src = fetchFromGitHub {
    owner = "lunatic-solutions";
    repo = "lunatic";
    rev = "28a2f387ebf6a64ce4b87e2638812e2c032d5049";
    hash = "sha256-FnUYnSWarQf68jBfSlIKVZbQHJt5U93MvA6rbNJE23U=";
  };

  cargoHash = "sha256-+2koGrhM9VMLh8uO1YcaugcfmZaCP4S2twKem+y2oks=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  checkFlags = [
    # requires simd support which is not always available on hydra
    "--skip=state::tests::import_filter_signature_matches"
  ];

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
    branch = "main";
  };

  meta = with lib; {
    description = "Erlang inspired runtime for WebAssembly";
    homepage = "https://lunatic.solutions";
    changelog = "https://github.com/lunatic-solutions/lunatic/blob/main/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
