{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {

  pname = "gofish";
  version = "1.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/gofish/gofish/${version}/${pname}-${version}.tar.gz";
    sha256 = "0br5nvlna86k4ya4q13gz0i7nlmk225lqmpfiqlkldxkr473kf0s";
  };

  meta = with lib; {
    description = "Lightweight Gopher server";
    homepage = "https://gofish.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
