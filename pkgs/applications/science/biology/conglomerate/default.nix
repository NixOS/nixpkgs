{ lib, stdenv, fetchFromGitHub, cmake, coreutils, perlPackages, bicpl, libminc, zlib, minc_tools,
  makeWrapper }:

stdenv.mkDerivation rec {
  pname = "conglomerate";
  version = "unstable-2017-09-10";

  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "7343238bc6215942c7ecc885a224f24433a291b0";
    sha256 = "1mlqgmy3jc13bv7d01rjwldxq0p4ayqic85xcl222hhifi3w2prr";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ libminc zlib bicpl ];
  propagatedBuildInputs = [ coreutils minc_tools ] ++ (with perlPackages; [ perl GetoptTabular MNI-Perllib ]);

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DBICPL_DIR=${bicpl}/lib"
  ];

  postFixup = ''
    for p in $out/bin/*; do
      wrapProgram $p --prefix PERL5LIB : $PERL5LIB --set PATH "${lib.makeBinPath [ coreutils minc_tools ]}";
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/conglomerate";
    description = "More command-line utilities for working with MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.hpndUc;
  };
}
