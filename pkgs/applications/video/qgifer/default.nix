{ stdenv, fetchsvn, cmake, opencv, qt, giflib }:

stdenv.mkDerivation rec {
  name = "qgifer-${version}";
  version = "0.2.1";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/qgifer/code/tags/${name}";
    sha256 = "0fv40n58xjwfr06ix9ga79hs527rrzfaq1sll3n2xxchpgf3wf4f";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "SET(CMAKE_INSTALL_PREFIX" "#"
  '';

  buildInputs = [ cmake opencv qt giflib ];

  meta = with stdenv.lib; {
    description = "Video-based animated GIF creator";
    homepage = https://sourceforge.net/projects/qgifer/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
