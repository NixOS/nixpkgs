{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  itk,
  Cocoa,
}:

stdenv.mkDerivation rec {
  pname = "c3d";
  version = "1.4.1-unstable-2024-08-07";

  src = fetchFromGitHub {
    owner = "pyushkevich";
    repo = "c3d";
    rev = "9e6174153ab87eae014f5b802413478c8fbc9a1a";
    hash = "sha256-s2/XRyKoiMnF6cRsxxNUSlNtksbOyKSlk8hAGxJELqw=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ itk ] ++ lib.optional stdenv.hostPlatform.isDarwin Cocoa;

  cmakeFlags = [ "-DCONVERT3D_USE_ITK_REMOTE_MODULES=OFF" ];

  meta = with lib; {
    homepage = "https://github.com/pyushkevich/c3d";
    description = "Medical imaging processing tool";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.gpl3;
    broken = stdenv.hostPlatform.isAarch64;
    # /build/source/itkextras/OneDimensionalInPlaceAccumulateFilter.txx:312:10: fatal error: xmmintrin.h: No such file or directory
  };
}
