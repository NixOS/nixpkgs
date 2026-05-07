{
  lib,
  rustPlatform,
  fetchCrate,
  perl,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hmm";
  version = "0.6.0";

  src = fetchCrate {
    pname = "hmmcli";
    inherit (finalAttrs) version;
    hash = "sha256-WPePzqZ2iGeJ7kzTj8eg7q1JEjw91WY7gViJJ46SLRY=";
  };

  cargoHash = "sha256-wyuV+jWY7w4VDn314yRkqmeqgRijPb+XgmUiy73U3Zc=";

  nativeCheckInputs = [
    perl
    writableTmpDirAsHomeHook
  ];
  # FIXME: remove patch when upstream version of rustc-serialize is updated
  # https://github.com/NixOS/nixpkgs/pull/310673
  cargoPatches = [ ./rustc-serialize-fix.patch ];

  meta = {
    description = "Small command-line note-taking app";
    homepage = "https://github.com/samwho/hmm";
    changelog = "https://github.com/samwho/hmm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
