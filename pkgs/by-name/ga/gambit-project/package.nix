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
<<<<<<< HEAD
  version = "16.4.1";
=======
  version = "16.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "gambitproject";
    repo = "gambit";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-jRjL/rQ3k0zdTFCx1S/jdYpijcBx1aV8zsC8mz8aZ3A=";
=======
    hash = "sha256-fiWGRL7U4A7FKmAvzYt6WjlkOe0jSq3U2VfxPFvc+FA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
