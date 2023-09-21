{ lib, stdenv, buildPackages, fetchurl, zlib, bzip2, perl, cpio, gawk, coreutils, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "blast";
  version = "2.14.1";

  src = fetchurl {
    url = "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-src.tar.gz";
    sha256 = "sha256-cSwtvfD7E8wcLU9O9d0c5LBsO1fpbf6o8j5umfWxZQ4=";
  };

  sourceRoot = "ncbi-blast-${version}+-src/c++";

  configureFlags = [
    # With flat Makefile we can use all_projects in order not to build extra.
    # These extra cause clang to hang on Darwin.
    "--with-flat-makefile"
    "--without-makefile-auto-update"
    "--with-dll"  # build dynamic libraries (static are default)
    ];

  makeFlags = [ "all_projects=app/" ];

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

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];

  # perl is necessary in buildInputs so that installed perl scripts get patched
  # correctly
  buildInputs = [ coreutils perl gawk zlib bzip2 cpio ]
    ++ lib.optionals stdenv.isDarwin [ ApplicationServices ];
  hardeningDisable = [ "format" ];

  postInstall = ''
    substituteInPlace $out/bin/get_species_taxids.sh \
        --replace /bin/rm ${coreutils}/bin/rm
  '';
  patches = [ ./no_slash_bin.patch ];

  enableParallelBuilding = true;

  # Many tests require either network access or locally available databases
  doCheck = false;

  meta = with lib; {
    description = ''Basic Local Alignment Search Tool (BLAST) finds regions of
    similarity between biological sequences'';
    homepage = "https://blast.ncbi.nlm.nih.gov/Blast.cgi";
    license = licenses.publicDomain;

    # Version 2.10.0 fails on Darwin
    # See https://github.com/NixOS/nixpkgs/pull/61430
    platforms = platforms.linux;
    maintainers = with maintainers; [ luispedro ];
  };
}
