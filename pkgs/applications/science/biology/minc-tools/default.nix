{ stdenv, fetchurl, perl, cmake, flex, bison, libminc }:

stdenv.mkDerivation rec {
  _name = "minc-tools";
  name  = "${_name}-2.3.00";

  src = fetchurl {
    url = "https://github.com/BIC-MNI/${_name}/archive/${_name}-2-3-00.tar.gz";
    sha256 = "1d457vrwy2fl6ga2axnwn1cchkx2rmgixfzyb1zjxb06cxkfj1dm";
  };

  nativeBuildInputs = [ cmake flex bison ] ++ (if doCheck then [ perl ] else [ ]);
  buildInputs = [ libminc ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/" ];

  checkPhase = "ctest";
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/BIC-MNI/minc-tools;
    description = "Command-line utilities for working with MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
  };
}
