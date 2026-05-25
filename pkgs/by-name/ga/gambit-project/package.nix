{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  stdenv,
  wxwidgets_3_1,
  withGui ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gambit-project";
  version = "16.6.0";

  src = fetchFromGitHub {
    owner = "gambitproject";
    repo = "gambit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4jtyFQVtde8ilTn5W/E6adQwX3fwC5T7EJU63mD2zM8=";
  };

  nativeBuildInputs = [ autoreconfHook ] ++ lib.optional withGui wxwidgets_3_1;

  buildInputs = lib.optional withGui wxwidgets_3_1;

  strictDeps = true;

  configureFlags = [
    (lib.enableFeature withGui "gui")
  ];

  meta = {
    description = "Open-source collection of tools for doing computation in game theory";
    homepage = "https://www.gambit-project.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
