{ lib, stdenv, fetchFromGitHub, cmake, itk4, Cocoa }:

stdenv.mkDerivation rec {
  pname   = "c3d";
  version = "unstable-2020-10-05";

  src = fetchFromGitHub {
    owner = "pyushkevich";
    repo = pname;
    rev = "0a87e3972ea403babbe2d05ec6d50855e7c06465";
    sha256 = "0wsmkifqrcfy13fnwvinmnq1m0lkqmpyg7bgbwnb37mbrlbq06wf";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ itk4 ]
    ++ lib.optional stdenv.isDarwin Cocoa;

  meta = with lib; {
    homepage = "https://github.com/pyushkevich/c3d";
    description = "Medical imaging processing tool";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.gpl3;
    broken = stdenv.isAarch64;
    # /build/git-3453f61/itkextras/OneDimensionalInPlaceAccumulateFilter.txx:311:10: fatal error: xmmintrin.h: No such file or directory
  };
}
