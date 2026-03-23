{
  lib,
  stdenv,
  fetchzip,
  installFonts,
}:

stdenv.mkDerivation rec {
  pname = "comic-neue";
  version = "2.51";

  src = fetchzip {
    url = "https://github.com/crozynski/comicneue/releases/download/${version}/comicneue-master.zip";
    hash = "sha256-Xkw+Yd36ffptKsS8RSEP9BPX6eQI7TZn2NgU49rdo80=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "http://comicneue.com/";
    description = "Casual type face: Make your lemonade stand look like a fortune 500 company";
    longDescription = ''
      ComicNeue is inspired by Comic Sans but more regular. It was
      designed by Craig Rozynski. It is available in two variants:
      Comic Neue and Comic Neue Angular. The former having round and
      the latter angular terminals. Both variants come in Light,
      Regular, and Bold weights with Oblique variants.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
