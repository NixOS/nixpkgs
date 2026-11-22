{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "open-dyslexic";
  version = "0.91.12";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "antijingoist";
    repo = "opendyslexic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a8hh8NGt5djj9EC7ChO3SnnjuYMOryzbHWTK4gC/vIw=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://opendyslexic.org/";
    description = "Font created to increase readability for readers with dyslexia";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
  };
})
