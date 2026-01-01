{
  lib,
  rustPlatform,
<<<<<<< HEAD
  fetchCrate,
  nix-update-script,
=======
  fetchFromGitHub,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

rustPlatform.buildRustPackage rec {
  pname = "genemichaels";
<<<<<<< HEAD
  version = "0.9.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-dXmIijGAcXuwtU9WbmuN1rAv7hY9Ah2JbGXAgPxq9k4=";
  };

  cargoHash = "sha256-+eIUNblWdR+OA27NCtT+rueh5EcwvTr3CGf80Cn/r+4=";

  passthru.updateScript = nix-update-script { };
=======
  version = "0.5.13";

  src = fetchFromGitHub {
    owner = "andrewbaxter";
    repo = "genemichaels";
    rev = "genemichaels-v${version}";
    hash = "sha256-pzGTKswETm7RR0up1eSWC+X633rsVmEAJ3DYM8z6paQ=";
  };

  cargoHash = "sha256-J7uibeoIKLC3jo5TstzC8udK+miAA52321eapOHVzbM=";

  cargoBuildFlags = [ "--package ${pname}" ];
  # cargoTestFlags is not used because genemichaels is tightly coupled to the
  # other crates in the workspace and by not setting it, we run all the tests.
  # If a dependency crate is failing its tests, we want to know about it. For
  # example, between versions 0.5.8 and 0.5.12, there was a failing test in one
  # of the other workspace members that genemichaels depends on.
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
}
