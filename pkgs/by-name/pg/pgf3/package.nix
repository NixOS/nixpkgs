{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pgf";
  version = "3.1.11";

  src = fetchFromGitHub {
    owner = "pgf-tikz";
    repo = "pgf";
    tag = finalAttrs.version;
    hash = "sha256-YBoGukCggj0jb1Y+EWZBoaW2XIQpb7ks/nHp4jsSBak=";
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
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
})
