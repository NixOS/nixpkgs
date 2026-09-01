{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pgfplots";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "pgf-tikz";
    repo = "pgfplots";
    tag = finalAttrs.version;
    hash = "sha256-QKXPhZBnyjUQQDMW4+hKSQf9ea97zIr7RDx7nXPjGpU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/texmf-nix
    cp -prd doc tex/{context,generic,latex,plain} $out/share/texmf-nix/

    runHook postInstall
  '';

  meta = {
    homepage = "https://pgfplots.sourceforge.net";
    description = "TeX package to draw plots directly in TeX in two and three dimensions";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
