{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mathmod";
  version = "12.0";

  src = fetchFromGitHub {
    owner = "parisolab";
    repo = "mathmod";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-h1iI7bheJVfE2+0m6Yk7QNCkl9Vye97tqb/WkQExVcQ=";
  };

  patches = [ ./fix-paths.patch ];

  postPatch = ''
    substituteInPlace MathMod.pro --subst-var out
  '';

  nativeBuildInputs = with libsForQt5; [
    qmake
    wrapQtAppsHook
  ];

  meta = {
    changelog = "https://github.com/parisolab/mathmod/releases/tag/${finalAttrs.version}";
    description = "Mathematical modelling software";
    homepage = "https://github.com/parisolab/mathmod";
    license = lib.licenses.gpl2Plus;
    mainProgram = "MathMod";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
})
