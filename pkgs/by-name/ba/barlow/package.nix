{
  lib,
  mkFont,
  fetchFromGitHub,
}:

mkFont (finalAttrs: {
  pname = "barlow";
  version = "1.422";

  src = fetchFromGitHub {
    owner = "jpt";
    repo = "barlow";
    tag = finalAttrs.version;
    hash = "sha256-FG68o6qN/296RhSNDHFXYXbkhlXSZJgGhVjzlJqsksY=";
  };

  installWebfonts = true;

  meta = {
    description = "Grotesk variable font superfamily";
    homepage = "https://tribby.com/fonts/barlow/";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
