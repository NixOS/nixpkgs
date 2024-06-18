{ lib, stdenv, fetchFromGitHub, cmake, itk_5_2, Cocoa }:

stdenv.mkDerivation rec {
  pname   = "c3d";
  version = "unstable-2021-09-14";

  src = fetchFromGitHub {
    owner = "pyushkevich";
    repo = pname;
    rev = "cc06e6e2f04acd3d6faa3d8c9a66b499f02d4388";
    sha256 = "sha256:1ql1y6694njsmdapywhppb54viyw8wdpaxxr1b3hm2rqhvwmhn52";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ itk_5_2 ]
    ++ lib.optional stdenv.isDarwin Cocoa;

  cmakeFlags = [ "-DCONVERT3D_USE_ITK_REMOTE_MODULES=OFF" ];

  meta = with lib; {
    homepage = "https://github.com/pyushkevich/c3d";
    description = "Medical imaging processing tool";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.gpl3;
    broken = stdenv.isAarch64;
    # /build/source/itkextras/OneDimensionalInPlaceAccumulateFilter.txx:312:10: fatal error: xmmintrin.h: No such file or directory
  };
}
