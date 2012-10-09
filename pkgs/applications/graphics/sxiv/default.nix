{ stdenv, fetchurl
, imlib2, libX11
}:

stdenv.mkDerivation rec {
  name = "sxiv-1.0";

  src = fetchurl {
    url = "https://github.com/downloads/muennich/sxiv/${name}.tar.gz";
    sha256 = "0pw82d8dlm1zgax9vn3y24jcb024zqwyk90aqlyvsff1gffihjgs";
  };

  buildInputs = [ imlib2 libX11 ];

  installPhase = "make PREFIX=$out install";

  meta = {
    homepage = "https://github.com/muennich/sxiv";
    description = "Simple (or small or suckless) X Image Viewer";
    license = "GPLv2";
  };
}
