{ stdenv, fetchurl, emacs, gmp, pcre, expat, autoconf, automake, libtool, texinfo }:

stdenv.mkDerivation {
  name = "ledger-2.6.3";

  src = fetchurl {
    url = "https://github.com/jwiegley/ledger/archive/v2.6.3.tar.gz";
    sha256 = "0fmawai1fakhvdmjrydxp2pl67vk1c1ff54z28xl2k057ws49hnm";
  };

  buildInputs = [ emacs gmp pcre expat autoconf automake libtool texinfo ];

  preConfigure = "autoreconf -vi";

  configureFlags = "CPPFLAGS=-DNDEBUG CFLAGS=-O3 CXXFLAGS=-O3";

  doCheck = true;

  # Patchelf breaks the hard-coded rpath to ledger's libamounts.so and
  # libledger-2.6.3. Fortunately, libtool chooses proper rpaths to begin
  # with, so we can just disable patchelf to avoid the issue.
  dontPatchELF = true;

  meta = {
    homepage = "http://ledger-cli.org/";
    description = "A double-entry accounting system with a command-line reporting interface";
    license = "BSD";

    longDescription = ''
      Ledger is a powerful, double-entry accounting system that is accessed
      from the UNIX command-line. This may put off some users, as there is
      no flashy UI, but for those who want unparalleled reporting access to
      their data, there really is no alternative.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
