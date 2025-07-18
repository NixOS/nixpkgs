{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libccd";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "danfis";
    repo = "libccd";
    rev = "v${version}";
    sha256 = "0sfmn5pd7k5kyhbxnd689xmsa5v843r7sska96dlysqpljd691jc";
  };

  patches = [
    # Fix pkgconfig file with absolute CMAKE_INSTALL_*DIR
    # https://github.com/danfis/libccd/pull/76
    (fetchpatch {
      url = "https://github.com/danfis/libccd/commit/cd16c4f168ae308e4c77db66ac97a2eaf47e059e.patch";
      sha256 = "02wj21c185kwf8bn4qi4cnna0ypzqm481xw9rr8jy1i0cb1r9idg";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Library for collision detection between two convex shapes";
    homepage = "https://github.com/danfis/libccd";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.unix;
  };
}
