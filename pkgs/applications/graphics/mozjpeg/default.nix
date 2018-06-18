{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libpng, nasm }:

stdenv.mkDerivation rec {
  version = "3.3.1";
  name = "mozjpeg-${version}";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "mozjpeg";
    rev = "v${version}";
    sha256 = "1na68860asn8b82ny5ilwbhh4nyl9gvx2yxmm4wr2v1v95v51fky";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libpng nasm ];

  meta = {
    description = "Mozilla JPEG Encoder Project";
    longDescription = ''
      This project's goal is to reduce the size of JPEG files without reducing quality or compatibility with the
      vast majority of the world's deployed decoders.

      The idea is to reduce transfer times for JPEGs on the Web, thus reducing page load times.
    '';
    homepage = https://github.com/mozilla/mozjpeg ;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.aristid ];
    platforms = stdenv.lib.platforms.all;
  };
}
