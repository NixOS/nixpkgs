{ lib, stdenv, fetchurl, pkg-config, libgnomeui, libxml2 }:

stdenv.mkDerivation rec {
  pname = "verbiste";

  version = "0.1.47";

  src = fetchurl {
    url = "https://perso.b2b2c.ca/~sarrazip/dev/${pname}-${version}.tar.gz";
    sha256 = "02kzin3pky2q2jnihrch8y0hy043kqqmzxq8j741x80kl0j1qxkm";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgnomeui libxml2 ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://sarrazip.com/dev/verbiste.html";
    description = "French and Italian verb conjugator";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
