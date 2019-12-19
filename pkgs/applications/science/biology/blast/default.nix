{ stdenv, fetchurl, zlib, bzip2, perl, cpio, gawk, coreutils }:

stdenv.mkDerivation rec {
  pname = "blast";
  version = "2.9.0";

  src = fetchurl {
    url = "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-src.tar.gz";
    sha256 = "0my2rpd1bln05sxnp4c5wk5j5y6yx56vi38pzicjfhh9g8nwr453";
  };

  sourceRoot = "ncbi-blast-${version}+-src/c++";
  
  configureFlags = [ "--without-makefile-auto-update" ];
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
              --replace /usr/bin/awk ${gawk}/bin/awk
    done

    for mk in src/build-system/Makefile.meta.in \
        src/build-system/helpers/run_with_lock.c ; do

        substituteInPlace $mk \
        --replace /bin/rm ${coreutils}/bin/rm
    done

    for mk in src/build-system/Makefile.meta.gmake=no \
        src/build-system/Makefile.meta_l \
        src/build-system/Makefile.meta_r \
        src/build-system/Makefile.requirements \
        src/build-system/Makefile.rules_with_autodep.in; do

        substituteInPlace $mk \
            --replace /bin/echo ${coreutils}/bin/echo
    done
    for mk in src/build-system/Makefile.meta_p \
        src/build-system/Makefile.rules_with_autodep.in \
        src/build-system/Makefile.protobuf.in ; do

        substituteInPlace $mk \
            --replace /bin/mv ${coreutils}/bin/mv
    done


    substituteInPlace src/build-system/configure \
        --replace /bin/pwd ${coreutils}/bin/pwd \
        --replace /bin/ln ${coreutils}/bin/ln

    substituteInPlace src/build-system/configure.ac \
        --replace /bin/pwd ${coreutils}/bin/pwd \
        --replace /bin/ln ${coreutils}/bin/ln

    substituteInPlace src/build-system/Makefile.meta_l \
        --replace /bin/date ${coreutils}/bin/date
  '';

  nativeBuildInputs = [ perl ];

  buildInputs = [ coreutils gawk zlib bzip2 cpio ];
  hardeningDisable = [ "format" ];

  patches = [ ./no_slash_bin.patch ];

  postInstall = ''
    # BLAST installs some unit test binaries, but several of them cannot be run
    # without the corresponding test databases, so clean up
    rm -f $out/bin/*_unit_test

    patchShebangs $out/bin/get_species_taxids.sh
    patchShebangs $out/bin/legacy_blast.pl
    patchShebangs $out/bin/update_blastdb.pl
  '';

  enableParallelBuilding = true;

  # Many tests require either network access or locally available databases
  doCheck = false;

  meta = with stdenv.lib; {
    description = ''Basic Local Alignment Search Tool (BLAST) finds regions of
    similarity between biological sequences'';
    homepage = https://blast.ncbi.nlm.nih.gov/Blast.cgi;
    license = licenses.publicDomain;
    platforms = platforms.unix;
    maintainers = with maintainers; [ luispedro ];
  };
}
