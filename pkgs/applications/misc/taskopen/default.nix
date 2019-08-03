{ fetchurl, stdenv, makeWrapper, which, perl, perlPackages }:

stdenv.mkDerivation rec {
  name = "taskopen-1.1.4";
  src = fetchurl {
    url = "https://github.com/ValiValpas/taskopen/archive/v1.1.4.tar.gz";
    sha256 = "774dd89f5c92462098dd6227e181268e5ec9930bbc569f25784000df185c71ba";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ which perl ] ++ (with perlPackages; [ JSON ]);

  installPhase = ''
    # We don't need a DESTDIR and an empty string results in an absolute path
    # (due to the trailing slash) which breaks the build.
    sed 's|$(DESTDIR)/||' -i Makefile

    make PREFIX=$out
    make PREFIX=$out install
  '';

  postFixup = ''
    wrapProgram $out/bin/taskopen \
         --set PERL5LIB "$PERL5LIB"
  '';

  meta = with stdenv.lib; {
    description = "Script for taking notes and open urls with taskwarrior";
    homepage = https://github.com/ValiValpas/taskopen;
    platforms = platforms.linux;
    license = stdenv.lib.licenses.free ;
    maintainers = [ maintainers.winpat ];
  };
}
