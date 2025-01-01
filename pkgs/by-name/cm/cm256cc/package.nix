{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "cm256cc";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "cm256cc";
    rev = "v${version}";
    sha256 = "sha256-T7ZUVVYGdzAialse//MoqWCVNBpbZvzWMAKc0cw7O9k=";
  };

  patches = [
    # Pull fix pending upstream inclusion for gcc-13 support:
    #   https://github.com/f4exb/cm256cc/pull/18
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/f4exb/cm256cc/commit/a7f142bcdae8be1c646d67176ba0ba0f7e8dcd68.patch";
      hash = "sha256-J7bm44sqnGsdPhJxQrE8LDxZ6tkTzLslHQnnKmtgrtM=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  # https://github.com/f4exb/cm256cc/issues/16
  postPatch = ''
    substituteInPlace libcm256cc.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  meta = with lib; {
    description = "Fast GF(256) Cauchy MDS Block Erasure Codec in C++";
    homepage = "https://github.com/f4exb/cm256cc";
    platforms = platforms.unix;
    maintainers = with maintainers; [ alkeryn ];
    license = licenses.gpl3;
  };
}
