{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mathmod";
  version = "13.0";

  src = fetchFromGitHub {
    owner = "parisolab";
    repo = "mathmod";
    tag = finalAttrs.version;
    hash = "sha256-+UR8Tk20StplyNqPDNxR0HfjAzAru4r+WtVsW81LR9c=";
  };

  patches = [
    ./fix-paths.patch
    (fetchpatch {
      # fix X > Y > Z comparison logic (which causes a compile error on darwin)
      name = "fix-comparison.patch";
      url = "https://github.com/parisolab/mathmod/commit/ddf9239f10fb0e07603297c06a23b7adeae8e323.patch";
      hash = "sha256-jB9y3xPwlcQYRQTnqcePjAZGycC1BpWhkT1GhgVJims=";
    })
  ];

  postPatch = ''
    substituteInPlace MathMod.pro \
      --replace-fail "@out@" "$out"
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
