{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pgfplots";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "pgf-tikz";
    repo = "pgfplots";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-cTfOMasBptm0lydKeNHPnjdEyFjEb88awYPn8S2m73c=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/texmf-nix
    cp -prd doc tex/{context,generic,latex,plain} $out/share/texmf-nix/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://pgfplots.sourceforge.net";
    description = "TeX package to draw plots directly in TeX in two and three dimensions";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
