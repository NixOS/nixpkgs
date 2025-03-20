{
  lib,
  rustPlatform,
  fetchCrate,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "hmm";
  version = "0.6.0";

  src = fetchCrate {
    pname = "hmmcli";
    inherit version;
    hash = "sha256-WPePzqZ2iGeJ7kzTj8eg7q1JEjw91WY7gViJJ46SLRY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-wyuV+jWY7w4VDn314yRkqmeqgRijPb+XgmUiy73U3Zc=";

  nativeCheckInputs = [
    perl
  ];
  # FIXME: remove patch when upstream version of rustc-serialize is updated
  # https://github.com/NixOS/nixpkgs/pull/310673
  cargoPatches = [ ./rustc-serialize-fix.patch ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Small command-line note-taking app";
    homepage = "https://github.com/samwho/hmm";
    changelog = "https://github.com/samwho/hmm/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
