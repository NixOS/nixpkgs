{
  lib,
  fetchFromGitHub,
  python3,
  installFonts,
  stdenvNoCC,
}:

let
  pname = "fira-math";
  date = "2023-10-09";
  version = "0.3.4-unstable-${date}";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "firamath";
    repo = "firamath";
    rev = "4bd85bc943eb6a194cfc090f7e194aa27d8f8419";
    hash = "sha256-1skakzdvzf7nX2un7b9aCSj1pzBAQuueZEU7B1nARa4=";
  };

  nativeBuildInputs = [
    installFonts
    (python3.withPackages (
      ps: with ps; [
        fontmake
        fonttools
        glyphslib
        toml
      ]
    ))
  ];

  buildPhase = ''
    runHook preBuild

    python scripts/build.py

    runHook postBuild
  '';

  meta = {
    description = "Math font with Unicode math support based on FiraSans and FiraGO";
    homepage = "https://github.com/firamath/firamath";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.loicreynier ];
    platforms = lib.platforms.all;
  };
}
