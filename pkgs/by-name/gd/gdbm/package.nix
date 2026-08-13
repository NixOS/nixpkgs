{
  lib,
  fetchurl,
  stdenv,
  testers,
  updateAutotoolsGnuConfigScriptsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gdbm";
  version = "1.26";

  src = fetchurl {
    url = "mirror://gnu/gdbm/gdbm-${finalAttrs.version}.tar.gz";
    hash = "sha256-aiRQShTeSnRBA9y5Nr6Xbfb76IzP8mBl5UwcR5RvSl4=";
  };

  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];

  hardeningDisable = [ "strictflexarrays3" ];

  configureFlags = [ (lib.enableFeature true "libgdbm-compat") ];

  outputs = [
    "out"
    "dev"
    "info"
    "lib"
    "man"
  ];

  doCheck = true;

  enableParallelBuilding = true;

  # 1. Linking static stubs on cygwin requires correct ordering. Consider
  #    upstreaming this.
  #
  # 2. Disable dbmfetch03.at test because it depends on unlink() failing on a
  #    link in a chmod -w directory, which cygwin apparently allows.
  postPatch = lib.optionalString stdenv.buildPlatform.isCygwin ''
    substituteInPlace tests/Makefile.in \
      --replace-fail '_LDADD = ../src/libgdbm.la ../compat/libgdbm_compat.la' \
                     '_LDADD = ../compat/libgdbm_compat.la ../src/libgdbm.la'
    substituteInPlace tests/testsuite.at
      --replace-fail 'm4_include([dbmfetch03.at])' ""
  '';

  # create symlinks for compatibility
  postInstall = ''
    install -dm755 ''${!outputDev}/include/gdbm
    pushd ''${!outputDev}/include/gdbm
    ln -s ../dbm.h dbm.h
    ln -s ../gdbm.h gdbm.h
    ln -s ../ndbm.h ndbm.h
    popd
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "gdbmtool --version";
    };
  };

  meta = {
    homepage = "https://www.gnu.org/software/gdbm/";
    description = "GNU dbm key/value database library";
    longDescription = ''
      GNU dbm (or GDBM, for short) is a library of database functions that use
      extensible hashing and work similar to the standard UNIX dbm. These
      routines are provided to a programmer needing to create and manipulate a
      hashed database.

      The basic use of GDBM is to store key/data pairs in a data file. Each
      key must be unique and each key is paired with only one data item.

      The library provides primitives for storing key/data pairs, searching and
      retrieving the data by its key and deleting a key along with its data.
      It also support sequential iteration over all key/data pairs in a
      database.

      For compatibility with programs using old UNIX dbm function, the package
      also provides traditional dbm and ndbm interfaces.
    '';
    license = lib.licenses.gpl3Plus;
    mainProgram = "gdbmtool";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
