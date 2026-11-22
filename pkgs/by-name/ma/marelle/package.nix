{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "marelle";
  version = "1.004";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitLab {
    domain = "forge.apps.education.fr";
    owner = "marelle";
    repo = "marelle.forge.apps.education.fr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BNUNHQ7Vjh34CPMd+YG2aVc1ttg65LUKH0ToJ1VAw2U=";
  };

  # public/fonts/ duplicates fonts/webfonts/
  postPatch = ''
    rm -rf public/fonts
  '';

  nativeBuildInputs = [
    installFonts
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Cursive font for teaching handwritting in primary school";
    homepage = "https://marelle.forge.apps.education.fr";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
