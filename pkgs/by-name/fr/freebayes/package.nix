{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  bzip2,
  xz,
}:

stdenv.mkDerivation rec {
  pname = "freebayes";
  version = "1.3.1";

  src = fetchFromGitHub {
    name = "freebayes-${version}-src";
    owner = "ekg";
    repo = "freebayes";
    rev = "v${version}";
    sha256 = "035nriknjqq8gvil81vvsmvqwi35v80q8h1cw24vd1gdyn1x7bys";
    fetchSubmodules = true;
  };

  buildInputs = [
    zlib
    bzip2
    xz
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: foomatic_rip-options.o:/build/foomatic-filters-4.0.17/options.c:49: multiple definition of `cupsfilter';
  #     foomatic_rip-foomaticrip.o:/build/foomatic-filters-4.0.17/foomaticrip.c:158: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  installPhase = ''
    install -vD bin/freebayes bin/bamleftalign scripts/* -t $out/bin
  '';

  meta = with lib; {
    description = "Bayesian haplotype-based polymorphism discovery and genotyping";
    license = licenses.mit;
    homepage = "https://github.com/ekg/freebayes";
    maintainers = with maintainers; [ jdagilliland ];
    platforms = [ "x86_64-linux" ];
  };
}
