{ stdenv, lib, cmake, pkgconfig, libogg, fetchFromGitHub, libiconv }:
stdenv.mkDerivation rec {
  pname = "opustags";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "fmang";
    repo = "opustags";
    rev = version;
    sha256 = "1dicv4s395b9gb4jpr0rnxdq9azr45pid62q3x08lb7cvyq3yxbh";
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
