{ stdenv, fetchFromGitHub, libXft, imlib2, giflib, libexif, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "sxiv";
  version = "25";

  src = fetchFromGitHub {
    owner = "muennich";
    repo = pname;
    rev = "v${version}";
    sha256 = "13s1lfar142hq1j7xld0ri616p4bqs57b17yr4d0b9a9w7liz4hp";
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
    maintainers = with maintainers; [ jfrankenau ];
  };
}
