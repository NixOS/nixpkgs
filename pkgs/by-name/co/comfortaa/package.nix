{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "comfortaa";
  version = "3.101-unstable-2021-07-29";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "comfortaa";
    rev = "2a87ac6f6ea3495150bfa00d0c0fb53dd0a2f11b";
    postFetch = ''
      # Remove the OTF fonts as they are not needed and cause a hash mismatch
      rm -r $out/fonts/{OTF,otf}
    '';
    hash = "sha256-4ZBRaQyYlnt9l4NgBHezuCnR3rKTJ37L41RTbGAhd0M=";
  };

  sourceRoot = "${finalAttrs.src.name}/fonts";

  nativeBuildInputs = [ installFonts ];

  dontBuild = true;

  postInstall = ''
    mkdir -p $out/share/doc/comfortaa
    cp ../FONTLOG.txt ../README.md $out/share/doc/comfortaa
  '';

  meta = {
    homepage = "http://aajohan.deviantart.com/art/Comfortaa-font-105395949";
    description = "Clean and modern font suitable for headings and logos";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
  };
})
