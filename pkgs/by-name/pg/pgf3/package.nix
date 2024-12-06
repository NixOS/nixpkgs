{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pgf";
  version = "3.1.10";

  src = fetchFromGitHub {
    owner = "pgf-tikz";
    repo = "pgf";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-/zU2aTV39XpQhSpHVi8pBNsaAshcIhl6s+vOL1SO3Vw=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/texmf-nix
    cp -prd doc source tex/{context,generic,latex,plain} $out/share/texmf-nix/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/pgf-tikz/pgf";
    description = "Portable Graphic Format for TeX - version ${finalAttrs.version}";
    branch = lib.versions.major version;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
