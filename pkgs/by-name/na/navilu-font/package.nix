{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fontforge,
}:

stdenvNoCC.mkDerivation rec {
  pname = "navilu-font";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "aravindavk";
    repo = "Navilu";
    rev = "v${version}";
    hash = "sha256-ijrRpvD3AM8aeZVV2/bQHYv8/hO63C+N+0CpqAmwpu4=";
  };

  nativeBuildInputs = [ fontforge ];

  dontConfigure = true;

  preBuild = "patchShebangs generate.pe";

  installPhase = "install -Dm444 -t $out/share/fonts/truetype/ Navilu.ttf";

  meta =

    src.meta // {
      description = "Kannada handwriting font";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.all;
    };
}
