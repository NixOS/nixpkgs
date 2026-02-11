{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  stdenv,
  wxGTK31,
  withGui ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gambit-project";
  version = "16.5.0";

  src = fetchFromGitHub {
    owner = "gambitproject";
    repo = "gambit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xoFtqPUC/qLrlEewIPeDmOH7rWMB+ak5CdVlH5t84MY=";
  };

  nativeBuildInputs = [ autoreconfHook ] ++ lib.optional withGui wxGTK31;

  buildInputs = lib.optional withGui wxGTK31;

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
