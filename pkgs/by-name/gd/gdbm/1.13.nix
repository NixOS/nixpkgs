{
  stdenv,
  lib,
  fetchurl,
}:
let
  pname = "gdbm";
  version = "1.13";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "mirror://gnu/gdbm/${pname}-${version}.tar.gz";
    sha256 = "0lx201q20dvc70f8a3c9s7s18z15inlxvbffph97ngvrgnyjq9cx";
  };

  doCheck = stdenv.buildPlatform == stdenv.hostPlatform;

  # Linking static stubs on cygwin requires correct ordering.
  # Consider upstreaming this.

  # Disable dbmfetch03.at test because it depends on unlink()
  # failing on a link in a chmod -w directory, which cygwin
  # apparently allows.
  postPatch =
    lib.optionalString stdenv.buildPlatform.isCygwin ''
      substituteInPlace tests/Makefile.in --replace-fail \
        '_LDADD = ../src/libgdbm.la ../compat/libgdbm_compat.la' \
        '_LDADD = ../compat/libgdbm_compat.la ../src/libgdbm.la'
      substituteInPlace tests/testsuite.at --replace-fail \
        'm4_include([dbmfetch03.at])' ""
    ''
    + ''
      # GCC>10 fix, see here: https://bugs.gentoo.org/705898
      substituteInPlace src/parseopt.c \
        --replace-fail "char *parseopt_program_doc;" "extern char *parseopt_program_doc;" \
        --replace-fail "char *parseopt_program_args;" "extern char *parseopt_program_args;"
    '';
  configureFlags = [ "--enable-libgdbm-compat" ];

  postInstall = ''
    # create symlinks for compatibility
    install -dm755 $out/include/gdbm
    (
      cd $out/include/gdbm
      ln -s ../gdbm.h gdbm.h
      ln -s ../ndbm.h ndbm.h
      ln -s ../dbm.h  dbm.h
    )
  '';

  meta = {
    description = "GNU dbm key/value database library";

    longDescription = ''
      GNU dbm (or GDBM, for short) is a library of database functions that
              use extensible hashing and work similar to the standard UNIX dbm.
              These routines are provided to a programmer needing to create and
              manipulate a hashed database.

              The basic use of GDBM is to store key/data pairs in a data file.
              Each key must be unique and each key is paired with only one data
              item.

              The library provides primitives for storing key/data pairs,
              searching and retrieving the data by its key and deleting a key
              along with its data.  It also support sequential iteration over all
              key/data pairs in a database.

              For compatibility with programs using old UNIX dbm function, the
              package also provides traditional dbm and ndbm interfaces.
    '';

    homepage = "http://www.gnu.org/software/gdbm/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.blenderfreaky ];
  };
}
