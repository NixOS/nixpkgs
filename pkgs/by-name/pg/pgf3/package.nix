{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pgf";
  version = "3.1.11a";

  src = fetchFromGitHub {
    owner = "pgf-tikz";
    repo = "pgf";
    tag = finalAttrs.version;
    hash = "sha256-+OxQ7sf5qh9hiVdCapJOUUwxDNsbvCXZEupN52wqldE=";
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
