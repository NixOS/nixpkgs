{ stdenv, fetchurl, substitute-paths
, bash, coreutils, diffutils, findutils, gawk, glibc, gnugrep, gnutar
, lmdb
}:

with stdenv.lib; let
  path = makeBinPath [
    bash coreutils diffutils findutils gawk glibc.bin gnugrep gnutar
  ];
in stdenv.mkDerivation rec {
  name = "ncbi-blast-${version}";
  version = "2.7.1";

  src = fetchurl {
    url = "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/${name}+-src.tar.gz";
    sha256 = "1jlq0afxxgczpp35k6mxh8mn4jzq7vqcnaixk166sfj10wq8v9qh";
  };

  nativeBuildInputs = [ substitute-paths ];

  buildInputs = [ lmdb ];

  sourceRoot = "${name}+-src/c++";

  postPatch = ''
    find scripts -name '*.sh' \
      -exec fgrep -q PATH=/bin:/usr/bin {} \; \
      -exec sed -e 's,^ *PATH=/bin:/usr/bin,#&,' -i {} \;

    find . -type f -exec substitute-paths -p ${path} {} +
    sed -i src/build-system/configure scripts/common/impl/if_diff.sh \
      -e 's#=/bin/#=${coreutils}/bin/#'

    configureScript=$(pwd)/configure

    unset AR
  '';

  configureFlags = [ "--with-dll" ];

  preBuild = ''
    cd ReleaseMT/build
  '';

  NCBICXX_RECONF_POLICY = "warn"; # Ignore the changes made in postPatch.

  makeFlags = [ "all_r" ];

  installPhase = ''
    mkdir -p $out
    cp -a ../bin ../lib $out
  '';

  enableParallelBuilding = true;
  hardeningDisable = [ "format" ];

  meta = {
    description = "Basic local alignment search tool";
    homepage = https://blast.ncbi.nlm.nih.gov/Blast.cgi;
    license = licenses.publicDomain;
    maintainers = [ maintainers.orivej ];
    platforms = platforms.all;
  };
}
