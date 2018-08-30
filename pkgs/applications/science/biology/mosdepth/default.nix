{stdenv, fetchFromGitHub, nim, htslib, pcre}:

let
  hts-nim = fetchFromGitHub {
    owner = "brentp";
    repo = "hts-nim";
    rev = "9cd83e30522ab64cd71eb8209be4154aa5579ce1";
    sha256 = "10g408idy14667varq1syf06rrbpk63i3ib7i5dh1md4ib19av6f";
  };

  docopt = fetchFromGitHub {
    owner = "docopt";
    repo = "docopt.nim";
    rev = "v0.6.5";
    sha256 = "0yx79m4jkdcazwlky55nwf39zj5kdhymrrdrjq29mahiwx83x5zr";
  };

in stdenv.mkDerivation rec {
  name = "mosdepth-${version}";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${version}";
    sha256 = "1b9frrwhcvay3alhn0d02jccc2qlbij1732hzq9nhwnr4kvsvxx7";
  };

  buildInputs = [ nim ];

  buildPhase = "nim -p:${hts-nim}/src -p:${docopt}/src c -d:release mosdepth.nim";
  installPhase = "install -Dt $out/bin mosdepth";
  fixupPhase = "patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ stdenv.cc.cc htslib pcre ]} $out/bin/mosdepth";

  meta = with stdenv.lib; {
    description = "fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing.";
    license = licenses.mit;
    homepage = https://github.com/brentp/mosdepth;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.linux;
  };
}
