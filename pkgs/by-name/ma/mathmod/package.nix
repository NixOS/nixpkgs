{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mathmod";
  version = "12.1";

  src = fetchFromGitHub {
    owner = "parisolab";
    repo = "mathmod";
    tag = finalAttrs.version;
    hash = "sha256-gDIYDXI9X24JAM1HP10EhJXkHZV2X8QngD5KPCUqdyI=";
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
