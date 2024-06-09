{ lib
, mkDerivation
, fetchFromGitHub
, qmake
}:

mkDerivation {
  pname = "mathmod";
  version = "11.1-unstable-2024-01-26";

  src = fetchFromGitHub {
    owner = "parisolab";
    repo = "mathmod";
    rev = "24d03a04c17363520ae7cf077e72a7b8684eb6fd";
    hash = "sha256-HiqHssPGqYEVZWchZRj4rFPc+xNVZk1ryl5qvFC2BmQ=";
  };

  patches = [ ./fix-paths.patch ];

  postPatch = ''
    substituteInPlace MathMod.pro --subst-var out
  '';

  nativeBuildInputs = [ qmake ];

  meta = {
    description = "A mathematical modelling software";
    homepage = "https://github.com/parisolab/mathmod";
    license = lib.licenses.gpl2Plus;
    mainProgram = "MathMod";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
}
