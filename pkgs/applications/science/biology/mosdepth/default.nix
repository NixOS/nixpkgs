{stdenv, fetchFromGitHub, nim, htslib, pcre}:

let
  hts-nim = fetchFromGitHub {
    owner = "brentp";
    repo = "hts-nim";
    rev = "v0.2.5";
    sha256 = "1fma99rjqxgg9dihkd10hm1jjp5amsk5wsxnvq1lk4mcsjix5xqb";
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

  buildPhase = ''
    HOME=$TMPDIR
    nim -p:${hts-nim}/src -p:${docopt}/src c --nilseqs:on -d:release mosdepth.nim
  '';
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
