{ fetchurl, lib, stdenv, makeWrapper, which, perl, perlPackages }:

stdenv.mkDerivation {
  name = "taskopen-1.1.5";
  src = fetchurl {
    url = "https://github.com/ValiValpas/taskopen/archive/v1.1.5.tar.gz";
    sha256 = "sha256-7fncdt1wCJ4zNLrCf93yRFD8Q4XQ3DCJ1+zJg9Gcl3w=";
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

  meta = with lib; {
    description = "Script for taking notes and open urls with taskwarrior";
    homepage = "https://github.com/ValiValpas/taskopen";
    platforms = platforms.linux;
    license = lib.licenses.free ;
    maintainers = [ maintainers.winpat ];
  };
}
