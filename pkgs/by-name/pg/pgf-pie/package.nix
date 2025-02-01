{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pgf-pie";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "pgf-tikz";
    repo = "pgf-pie";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-tAUv35AMgJW5JI2KIXxxXFihqdB7qbMmNpAYhpDbAxs=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/texmf-nix
    cp -prd doc tex/latex $out/share/texmf-nix/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/pgf-tikz/pgf-pie";
    description = "Some LaTeX macros for pie charts using the PGF/TikZ package";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
