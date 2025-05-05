{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  zlib,
  perl,
  perlPackages,
  openmp,
}:

stdenv.mkDerivation rec {
  version = "4.8.1";
  pname = "cd-hit";

  src = fetchFromGitHub {
    owner = "weizhongli";
    repo = "cdhit";
    rev = "V${version}";
    sha256 = "032nva6iiwmw59gjipm1mv0xlcckhxsf45mc2qbnv19lbis0q22i";
  };

  propagatedBuildInputs = [
    perl
    perlPackages.TextNSP
    perlPackages.ImageMagick
  ];

  nativeBuildInputs = [
    zlib
    makeWrapper
  ];
  buildInputs = lib.optional stdenv.cc.isClang openmp;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}c++" # remove once https://github.com/weizhongli/cdhit/pull/114 is merged
    "PREFIX=$(out)/bin"
  ];

  preInstall = "mkdir -p $out/bin";

  postFixup = ''
    wrapProgram $out/bin/FET.pl --prefix PERL5LIB : $PERL5LIB
    wrapProgram $out/bin/plot_2d.pl --prefix PERL5LIB : $PERL5LIB
    wrapProgram $out/bin/clstr_list_sort.pl --prefix PERL5LIB : $PERL5LIB
  '';
  meta = with lib; {
    description = "Clustering and comparing protein or nucleotide sequences";
    homepage = "http://weizhongli-lab.org/cd-hit/";
    license = licenses.gpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };
}
