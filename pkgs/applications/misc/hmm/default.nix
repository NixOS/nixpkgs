{ lib
, rustPlatform
, fetchCrate
, perl
}:

rustPlatform.buildRustPackage rec {
  pname = "hmm";
  version = "0.6.0";

  src = fetchCrate {
    pname = "hmmcli";
    inherit version;
    hash = "sha256-WPePzqZ2iGeJ7kzTj8eg7q1JEjw91WY7gViJJ46SLRY=";
  };

  cargoHash = "sha256-9Z49aPfcIdMfYCFAXsxFxcfhaLjtPod+nMFHDmvgDY0=";

  nativeCheckInputs = [
    perl
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "A small command-line note-taking app";
    homepage = "https://github.com/samwho/hmm";
    changelog = "https://github.com/samwho/hmm/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
