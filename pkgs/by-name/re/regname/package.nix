{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "regname";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "linkdd";
    repo = "regname";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zKsWEjFMTFibzfZ2dEc+RN74Ih1jr9vJhOUU0gY1rYE=";
  };

  cargoHash = "sha256-6iRDUOXPDzlD11JEL4at+z3aWkhn/dECtl7y2/vGMwo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mass renamer TUI written in Rust";
    homepage = "https://github.com/linkdd/regname";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ilarvne ];
    mainProgram = "regname";
  };
})
