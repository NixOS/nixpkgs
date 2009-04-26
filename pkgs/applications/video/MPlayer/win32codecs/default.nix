{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "MPlayer-codecs-essential-20071007";
  
  src = fetchurl {
    url = http://www2.mplayerhq.hu/MPlayer/releases/codecs/essential-20071007.tar.bz2;
    sha256 = "18vls12n12rjw0mzw4pkp9vpcfmd1c21rzha19d7zil4hn7fs2ic";
  };

  installPhase = ''
    mkdir $out
    cp -prv * $out
  '';
  
  meta = {
    license = "unfree";
  };
}
