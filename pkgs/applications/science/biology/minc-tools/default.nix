{ stdenv, fetchFromGitHub, perl, cmake, flex, bison, libminc }:

stdenv.mkDerivation rec {
  name = "${pname}-2.3.00";
  pname = "minc-tools";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = pname;
    rev = builtins.replaceStrings [ "." ] [ "-" ] name;
    sha256 = "0px5paprx4ds9aln3jdg1pywszgyz2aykgkdbj1y8gc1lwcizsl9";
  };

  nativeBuildInputs = [ cmake flex bison ] ++ (if doCheck then [ perl ] else [ ]);
  buildInputs = [ libminc ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/" ];

  checkPhase = "ctest";
  doCheck = false;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/BIC-MNI/minc-tools;
    description = "Command-line utilities for working with MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
  };
}
