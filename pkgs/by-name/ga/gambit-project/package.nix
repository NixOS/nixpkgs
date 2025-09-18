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
  version = "16.4.0";

  src = fetchFromGitHub {
    owner = "gambitproject";
    repo = "gambit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fiWGRL7U4A7FKmAvzYt6WjlkOe0jSq3U2VfxPFvc+FA=";
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
