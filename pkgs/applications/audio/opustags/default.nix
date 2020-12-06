{ stdenv, lib, cmake, pkgconfig, libogg, fetchFromGitHub, libiconv }:
stdenv.mkDerivation rec {
  pname = "opustags";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "fmang";
    repo = "opustags";
    rev = version;
    sha256 = "1y0czl72paawy342ff9ickaamkih43k59yfcdw7bnddypyfa7nbg";
  };

  buildInputs = [ libogg ];

  nativeBuildInputs = [ cmake pkgconfig ] ++ lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    homepage = "https://github.com/fmang/opustags";
    description = "Ogg Opus tags editor";
    platforms = platforms.all;
    maintainers = [ maintainers.kmein ];
    license = licenses.bsd3;
  };
}
