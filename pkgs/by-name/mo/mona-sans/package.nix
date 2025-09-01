{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mona-sans";
  version = "2.0";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "github";
    repo = "mona-sans";
    sha256 = "sha256-pFc6EUzf4FlA0LVdDEnFNr7m5V1FLc4jTAvtZdOslTg=";
  };

  installPhase = ''
    install -D -m444 -t $out/share/fonts/opentype fonts/otf/*.otf
    install -D -m444 -t $out/share/fonts/truetype fonts/ttf/*.ttf fonts/variable/*.ttf
  '';

  meta = {
    description = "Variable font from GitHub";
    homepage = "https://github.com/mona-sans";
    changelog = "https://github.com/github/mona-sans/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.ofl;
    longDescription = ''
      A strong and versatile typeface, designed together with Degarism and
      inspired by industrial-era grotesques. Mona Sans works well across
      product, web, and print. Made to work well together with Mona Sans's
      sidekick, Hubot Sans.

      Mona Sans is a variable font. Variable fonts enable different variations
      of a typeface to be incorporated into one single file, and are supported
      by all major browsers, allowing for performance benefits and granular
      design control of the typeface's weight, width, and slant.
    '';
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
