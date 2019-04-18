{ fetchFromRepoOrCz, stdenv, perl }:

stdenv.mkDerivation {
  name = "git2cl-20080827";

  src = fetchFromRepoOrCz {
    repo = "git2cl";
    rev = "8373c9f74993e218a08819cbcdbab3f3564bbeba";
    sha256 = "0bqzqal8w8fypv38xv48rkhqr47p44hiwhs22j1152hcciwr7lxh";
  };

  buildInputs = [ perl ];
  installPhase = ''
    install -D -m755 git2cl $out/bin/git2cl
    install -D -m644 README $out/share/doc/git2cl/README
  '';

  meta = {
    homepage = http://josefsson.org/git2cl/;
    description = "Convert git logs to GNU style ChangeLog files";
    platforms = stdenv.lib.platforms.unix;
  };
}
