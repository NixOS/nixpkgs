{ stdenv, fetchurl
, ninja, libxml2, libxslt, readline, perl, gmp, mpfr, boost
, bliss, ppl, singular, cddlib, lrs, nauty
, ant, openjdk
, perlPackages
, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "polymake";
  version = "3.2.rc4";

  src = fetchurl {
    url = "https://polymake.org/lib/exe/fetch.php/download/polymake-3.2r4.tar.bz2";
    sha256 = "02jpkvy1cc6kc23vkn7nkndzr40fq1gkb3v257bwyi1h5d37fyqy";
  };

  buildInputs = [
    libxml2 libxslt readline perl gmp mpfr boost
    bliss ppl singular cddlib lrs nauty
    openjdk
  ] ++
  (with perlPackages; [
    XMLLibXML XMLLibXSLT XMLWriter TermReadLineGnu TermReadKey
  ]);

  nativeBuildInputs = [
    makeWrapper ninja ant perl
  ];

  ninjaFlags = "-C build/Opt";

  postInstall = ''
    for i in "$out"/bin/*; do
      wrapProgram "$i" --prefix PERL5LIB : "$PERL5LIB"
    done
  '';

  meta = {
    inherit version;
    description = "Software for research in polyhedral geometry";
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://www.polymake.org/doku.php";
  };
}
