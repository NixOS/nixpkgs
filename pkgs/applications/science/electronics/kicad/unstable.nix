{ stdenv, fetchFromGitHub, cmake, mesa, wxGTK, zlib, libX11, gettext, glew, glm, cairo, curl, openssl, boost, pkgconfig, doxygen }:

stdenv.mkDerivation rec {
  name = "kicad-unstable-${version}";
  version = "2017-12-11";

  src = fetchFromGitHub {
      owner = "KICad";
      repo = "kicad-source-mirror";
      rev = "1955f252265c38a313f6c595d6c4c637f38fd316";
      sha256 = "15cc81h7nh5dk6gj6mc4ylcgdznfriilhb43n1g3xwyq3s8iaibz";
    };

  cmakeFlags = ''
    -DKICAD_SKIP_BOOST=ON
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake mesa wxGTK zlib libX11 gettext glew glm cairo curl openssl boost doxygen ];

  meta = {
    description = "Free Software EDA Suite, Nightly Development Build";
    homepage = http://www.kicad-pcb.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ berce ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
