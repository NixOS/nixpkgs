{ stdenv, fetchgit, cmake, itk, Cocoa }:

stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  pname   = "c3d";
  version = "1.1.0";

  src = fetchgit {
    url = "https://git.code.sf.net/p/c3d/git";
    rev = "3453f6133f0df831dcbb0d0cfbd8b26e121eb153";
    sha256 = "1xgbk20w22jwvf7pa0n4lcbyx35fq56zzlslj0nvcclh6vx0b4z8";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ itk ]
    ++ stdenv.lib.optional stdenv.isDarwin Cocoa;

  meta = with stdenv.lib; {
    homepage = http://www.itksnap.org/c3d;
    description = "Medical imaging processing tool";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
