{ stdenv, lib, cmake, pkgconfig, libogg, fetchFromGitHub, libiconv }:
stdenv.mkDerivation rec {
  pname = "opustags";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "fmang";
    repo = "opustags";
    rev = version;
    sha256 = "191zx2g3lijybgcy3a4fz5l35cagdrcdr0difhcfz0zn60hwnvqc";
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
