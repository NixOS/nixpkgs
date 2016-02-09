{ stdenv, fetchFromGitHub, libX11, imlib2, giflib, libexif }:

stdenv.mkDerivation rec {
  name = "sxiv-${version}";
  version = "v1.3.2";
  #https://github.com/muennich/sxiv/archive/v1.3.2.zip
  src = fetchFromGitHub {
    owner = "muennich";
    repo = "sxiv";
    rev = version;
    sha256 = "1f4gz1qjhb44bbb3q5fqk439zyipkwnr19zhg89yq2pgmzzzqr2h";
  };

  postUnpack = ''
    substituteInPlace $sourceRoot/Makefile \
      --replace /usr/local $out
  '';

  buildInputs = [ libX11 imlib2 giflib libexif ];
  meta = {
    description = "Simple X Image Viewer";
    homepage = "https://github.com/muennich/sxiv";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
