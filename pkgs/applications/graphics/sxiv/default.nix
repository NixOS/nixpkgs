{ stdenv, fetchFromGitHub, libXft, imlib2, giflib, libexif, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "sxiv-${version}";
  version = "24";

  src = fetchFromGitHub {
    owner = "muennich";
    repo = "sxiv";
    rev = "v${version}";
    sha256 = "020n1bdxbzqncprh8a4rnjzc4frp335yxbqh5w6dr970f7n5qm8d";
  };

  postUnpack = ''
    substituteInPlace $sourceRoot/Makefile \
      --replace /usr/local $out
  '';

  configFile = optionalString (conf!=null) (builtins.toFile "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  buildInputs = [ libXft imlib2 giflib libexif ];

  postInstall = ''
    mkdir -p $out/share/applications/
    cp -v sxiv.desktop $out/share/applications/
  '';

  meta = {
    description = "Simple X Image Viewer";
    homepage = https://github.com/muennich/sxiv;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ jfrankenau fuuzetsu ];
  };
}
