{ stdenv, fetchgit, cmake, itk4, Cocoa }:

stdenv.mkDerivation {
  pname   = "c3d";
  version = "unstable-2019-10-22";

  src = fetchgit {
    url    = "https://github.com/pyushkevich/c3d";
    rev    = "c04e2b84568654665c64d8843378c8bbd58ba9b0";
    sha256 = "0lzldxvshl9q362mg76byc7s5zc9qx7mxf2wgyij5vysx8mihx3q";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ itk4 ]
    ++ stdenv.lib.optional stdenv.isDarwin Cocoa;

  meta = with stdenv.lib; {
    homepage = http://www.itksnap.org/c3d;
    description = "Medical imaging processing tool";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.gpl2;
    broken = stdenv.isAarch64;
    # /build/git-3453f61/itkextras/OneDimensionalInPlaceAccumulateFilter.txx:311:10: fatal error: xmmintrin.h: No such file or directory
  };
}
