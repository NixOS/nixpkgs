{
  lib,
  stdenvNoCC,
  fetchgit,
  fontforge,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "newcomputermodern";
  version = "6.0.0";

  src = fetchgit {
    url = "https://git.gnu.org.ua/newcm.git";
    rev = finalAttrs.version;
    hash = "sha256-AMzEytBn9PbyYFNJ2CMPg8ejsL3eFhY+eZHXShaLG9E=";
  };

  nativeBuildInputs = [ fontforge ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    for i in sfd/*.sfd; do
      fontforge -lang=ff -c \
        'Open($1);
        Generate($1:r + ".otf");
        ' $i;
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -m444 -Dt $out/share/fonts/opentype/public sfd/*.otf
    runHook postInstall
  '';

  meta = {
    description = "Computer Modern fonts including matching non-latin alphabets";
    homepage = "https://ctan.org/pkg/newcomputermodern";
    # "The GUST Font License (GFL), which is a free license, legally
    # equivalent to the LaTeX Project Public License (LPPL), version 1.3c or
    # later." - GUST website
    license = lib.licenses.lppl13c;
    maintainers = [ lib.maintainers.drupol ];
    platforms = lib.platforms.all;
  };
})
