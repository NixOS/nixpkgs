{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pgf";
  version = "3.1.12";

  src = fetchFromGitHub {
    owner = "pgf-tikz";
    repo = "pgf";
    tag = finalAttrs.version;
    hash = "sha256-rn1C/KlFA3zjKa7wQpSUE0Bg407rNxbk+d4C0bf9EVc=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/texmf-nix
    cp -prd doc source tex/{context,generic,latex,plain} $out/share/texmf-nix/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/pgf-tikz/pgf";
    description = "Portable Graphic Format for TeX - version ${finalAttrs.version}";
    branch = lib.versions.major finalAttrs.version;
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
