{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "genemichaels";
  version = "0.5.13";

  src = fetchFromGitHub {
    owner = "andrewbaxter";
    repo = "genemichaels";
    rev = "genemichaels-v${version}";
    hash = "sha256-pzGTKswETm7RR0up1eSWC+X633rsVmEAJ3DYM8z6paQ=";
  };

  cargoHash = "sha256-FjggpBTzxj9AOJjUq5PmbuE/ImmTMpxN0se9uxRy4KQ=";

  cargoBuildFlags = [ "--package ${pname}" ];
  # cargoTestFlags is not used because genemichaels is tightly coupled to the
  # other crates in the workspace and by not setting it, we run all the tests.
  # If a dependency crate is failing its tests, we want to know about it. For
  # example, between versions 0.5.8 and 0.5.12, there was a failing test in one
  # of the other workspace members that genemichaels depends on.

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
}
