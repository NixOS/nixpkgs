{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  zlib,
  bzip2,
  perl,
  cpio,
  gawk,
  coreutils,
  curl,
  # Required for 2.17.0 full build (partial build via all_projects=app/ has seqdb dependency issues)
  boost,
  libuv,
  libssh,
  fastcgipp,
  sqlite, # required for seqdb
}:

stdenv.mkDerivation rec {
  pname = "blast";
  version = "2.17.0";

  src = fetchurl {
    url = "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-src.tar.gz";
    hash = "sha256-UCBXqI6ZkONOYnWL4h6kdMwK1o1qY6LjeyNyrx5eoUc=";
  };

  sourceRoot = "ncbi-blast-${version}+-src/c++";

  configureFlags = [
    # With flat Makefile we can use all_projects in order not to build extra.
    # These extra cause clang to hang on Darwin.
    "--with-flat-makefile"
    "--without-makefile-auto-update"
    "--with-dll" # build dynamic libraries (static are default)
    "--with-sqlite3=${sqlite.dev}" # required for seqdb
    # Use project list with unit tests excluded
    "--with-projects=scripts/projects/blast/project.lst"
  ];

  preConfigure = ''
    export NCBICXX_RECONF_POLICY=warn
    export PWD=$(pwd)
    export HOME=$PWD

    # The configure scripts wants to set AR="ar cr" unless it is already set in
    # the environment. Because stdenv sets AR="ar", the result is a bad call to
    # the assembler later in the process. Thus, we need to unset AR
    unset AR

    for awks in scripts/common/impl/is_log_interesting.awk \
        scripts/common/impl/report_duplicates.awk; do
      substituteInPlace $awks \
        --replace-fail "/usr/bin/awk" "${gawk}/bin/awk"
    done

    for mk in src/build-system/Makefile.meta.in \
        src/build-system/helpers/run_with_lock.c ; do
      substituteInPlace $mk \
        --replace-fail "/bin/rm" "${coreutils}/bin/rm"
    done

    for mk in src/build-system/Makefile.meta.gmake=no \
        src/build-system/Makefile.meta_l \
        src/build-system/Makefile.meta_r \
        src/build-system/Makefile.requirements \
        src/build-system/Makefile.rules_with_autodep.in; do
      substituteInPlace $mk \
        --replace-fail "/bin/echo" "${coreutils}/bin/echo"
    done

    for mk in src/build-system/Makefile.meta_p \
        src/build-system/Makefile.rules_with_autodep.in \
        src/build-system/Makefile.protobuf.in ; do
      substituteInPlace $mk \
        --replace-fail "/bin/mv" "${coreutils}/bin/mv"
    done

    substituteInPlace src/build-system/configure \
        --replace-fail "/bin/pwd" "${coreutils}/bin/pwd" \
        --replace-fail "/bin/ln" "${coreutils}/bin/ln"

    substituteInPlace src/build-system/configure.ac \
        --replace-fail "/bin/pwd" "${coreutils}/bin/pwd" \
        --replace-fail "/bin/ln" "${coreutils}/bin/ln"

    substituteInPlace src/build-system/Makefile.meta_l \
        --replace-fail "/bin/date" "${coreutils}/bin/date"

    # Exclude unit tests from build (Boost.Test 1.87 / GCC 15 incompatibility)
    sed -i 's|^algo/blast/unit_tests$|-algo/blast/unit_tests|' scripts/projects/blast/project.lst
    sed -i 's|^algo/blast/blastinput/unit_test$|-algo/blast/blastinput/unit_test|' scripts/projects/blast/project.lst
    # Also exclude other unit tests (included via parent dirs without $ suffix)
    sed -i '/^objtools\/blast\/seqdb_writer$/a -objtools/blast/seqdb_writer/unit_test' scripts/projects/blast/project.lst
    sed -i '/^objtools\/blast\/blastdb_format$/a -objtools/blast/blastdb_format/unit_test' scripts/projects/blast/project.lst
    sed -i '/^objtools\/blast\/services$/a -objtools/blast/services/unit_test' scripts/projects/blast/project.lst
    sed -i '/^objtools\/align_format$/a -objtools/align_format/unit_test' scripts/projects/blast/project.lst
    sed -i '/^algo\/blast\/proteinkmer$/a -algo/blast/proteinkmer/unit_test' scripts/projects/blast/project.lst
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    cpio
    perl
  ];

  # perl is necessary in buildInputs so that installed perl scripts get patched
  # correctly
  buildInputs = [
    coreutils
    perl
    gawk
    zlib
    bzip2
    boost
    libuv
    libssh
    fastcgipp
    sqlite
  ];

  strictDeps = true;

  hardeningDisable = [ "format" ];

  postInstall = ''
    substituteInPlace $out/bin/get_species_taxids.sh \
        --replace-fail "/bin/rm" "${coreutils}/bin/rm"

    substituteInPlace $out/bin/update_blastdb.pl \
        --replace-fail 'qw(/usr/local/bin /usr/bin)' 'qw(${curl}/bin)'
  '';

  patches = [ ./no_slash_bin.patch ];

  enableParallelBuilding = true;

  # Many tests require either network access or locally available databases
  doCheck = false;

  meta = {
    description = "Basic Local Alignment Search Tool (BLAST) finds regions of similarity between biological sequences";
    homepage = "https://blast.ncbi.nlm.nih.gov/Blast.cgi";
    license = lib.licenses.publicDomain;
    # Version 2.10.0 fails on Darwin
    # See https://github.com/NixOS/nixpkgs/pull/61430
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ luispedro ];
  };
}
