{ stdenv, fetchFromGitHub, cmake, boost, libpng, zlib }:

stdenv.mkDerivation rec {
  pname = "apngasm";
  version = "3.1.9";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "d50bfb0cf14c376f4cfb94eb91c61d795a76b715"; # not tagged, but in debian/changelog
    sha256 = "0pk0r8x1950pm6j3d5wgryvy3ldm7a9gl59jmnwnjmg1sf9mzf97";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost libpng zlib ];

  meta = with stdenv.lib; {
    description = "Create an APNG from multiple PNG files";
    homepage = "https://github.com/apngasm/apngasm";
    license = licenses.zlib;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };

}
