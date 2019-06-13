{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "3.99-u4-b5";
  pname = "monkeys-audio";
  name = pname + "-" + version;

  patches = [ ./buildfix.diff ];

  src = fetchurl {
    url = "https://deb-multimedia.org/pool/main/m/${pname}/${pname}_${version}.orig.tar.gz";
    sha256 = "0kjfwzfxfx7f958b2b1kf8yj655lp0ppmn0sh57gbkjvj8lml7nz";
  };

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
