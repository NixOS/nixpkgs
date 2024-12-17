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

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
}
