{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pgf-umlcd";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "pgf-tikz";
    repo = "pgf-umlcd";
    tag = finalAttrs.version;
    hash = "sha256-92bfBcQfnalYoVxlVRjbRXhWt+CbS8PtiMmFIqbgo7A=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/texmf-nix
    cp -prd doc tex/latex $out/share/texmf-nix/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/pgf-tikz/pgf-umlcd";
    description = "Some LaTeX macros for UML Class Diagrams";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
})
