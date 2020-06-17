{ stdenv, fetchFromGitHub, makeWrapper, zlib, perl, perlPackages }:

stdenv.mkDerivation rec {
  version = "4.8.1";
  pname = "cd-hit";

  src = fetchFromGitHub {
    owner = "weizhongli";
    repo = "cdhit";
    rev = "V${version}";
    sha256 = "032nva6iiwmw59gjipm1mv0xlcckhxsf45mc2qbnv19lbis0q22i";
  };

  propagatedBuildInputs = [ perl perlPackages.TextNSP perlPackages.PerlMagick perlPackages.Storable ];

  nativeBuildInputs = [ zlib makeWrapper ];

  makeFlags = [ "PREFIX=$(out)/bin" ];

  preInstall = "mkdir -p $out/bin";

  postFixup = ''
    wrapProgram $out/bin/FET.pl --prefix PERL5LIB : $PERL5LIB
    wrapProgram $out/bin/plot_2d.pl --prefix PERL5LIB : $PERL5LIB
    wrapProgram $out/bin/clstr_list_sort.pl --prefix PERL5LIB : $PERL5LIB
  '';
  meta = with stdenv.lib; {
    description = "Clustering and comparing protein or nucleotide sequences";
    homepage = "http://weizhongli-lab.org/cd-hit/";
    license = licenses.gpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };
}
