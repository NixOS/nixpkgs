{ fetchgit, stdenv, perl }:

stdenv.mkDerivation {
  name = "git2cl-20080827";

  src = fetchgit {
    url = "git://repo.or.cz/git2cl.git";
    rev = "8373c9f74993e218a08819cbcdbab3f3564bbeba";
    sha256 = "b0d39379640c8a12821442431e2121f7908ce1cc88ec8ec6bede218ea8c21f2f";
  };

  buildInputs = [ perl ];
  installPhase = ''
    install -D -m755 git2cl $out/bin/git2cl
    install -D -m644 README $out/share/doc/git2cl/README
  '';

  meta = {
    homepage = "http://josefsson.org/git2cl/";
    description = "Convert git logs to GNU style ChangeLog files";
    platforms = stdenv.lib.platforms.unix;
  };
}
