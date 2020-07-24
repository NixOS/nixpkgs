{ stdenv, fetchurl, ncurses, autoreconfHook, flex }:
let rev = "431604647f89d5aac7b199a7883e98e56e4ccf9e";
in stdenv.mkDerivation rec {
  pname = "mmh-unstable";
  version = "2019-09-08";

  src = fetchurl {
    url = "http://git.marmaro.de/?p=mmh;a=snapshot;h=${rev};sf=tgz";
    name = "mmh-${rev}.tgz";
    sha256 = "1q97p4g3f1q2m567i2dbx7mm7ixw3g91ww2rymwj42cxk9iyizhv";
  };

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ autoreconfHook flex ];

  meta = with stdenv.lib; {
    description = "Set of electronic mail handling programs";
    homepage = "http://marmaro.de/prog/mmh";
    license = licenses.bsd3;
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ kaction ];
  };
}
