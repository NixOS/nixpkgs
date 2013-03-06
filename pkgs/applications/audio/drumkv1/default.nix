{ stdenv, fetchurl, jackaudio, libsndfile, lv2, qt4 }:

stdenv.mkDerivation rec {
  name = "drumkv1-${version}";
  version = "0.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/${name}.tar.gz";
    sha256 = "0bafg06iavri9dmg7hpz554kpqf1iv9crcdq46y4n4wyyxd7kajl";
  };

  buildInputs = [ jackaudio libsndfile lv2 qt4 ];

  meta = with stdenv.lib; {
    description = "";
    homepage = http://drumkv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}