{ stdenv, lib, cmake, pkgconfig, libogg, fetchFromGitHub, libiconv }:
stdenv.mkDerivation rec {
  pname = "opustags";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "fmang";
    repo = "opustags";
    rev = version;
    sha256 = "09z0cdg20algaj2yyhfz3hxh1biwjjvzx1pc2vdc64n8lkswqsc1";
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
