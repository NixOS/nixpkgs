{
  lib,
  stdenv,
  libpng,
  libuuid,
  zlib,
  bzip2,
  xz,
  openssl,
  curl,
  libmysqlclient,
  bash,
  fetchFromGitHub,
  which,
}:
stdenv.mkDerivation rec {
  pname = "kent";
  version = "468";

  src = fetchFromGitHub {
    owner = "ucscGenomeBrowser";
    repo = pname;
    rev = "v${version}_base";
    hash = "sha256-OM/noraW2X8WV5wqWEFiI5/JPOBmsp0fTeDdcZoXxAA=";
  };

  buildInputs = [
    libpng
    libuuid
    zlib
    bzip2
    xz
    openssl
    curl
    libmysqlclient
  ];

  postPatch = ''
    substituteInPlace ./src/checkUmask.sh \
      --replace "/bin/bash" "${bash}/bin/bash"

    substituteInPlace ./src/hg/sqlEnvTest.sh \
      --replace "which mysql_config" "${which}/bin/which ${libmysqlclient}/bin/mysql_config"
  '';

  buildPhase = ''
    runHook preBuild

    export MACHTYPE=$(uname -m)
    export CFLAGS="-fPIC"
    export MYSQLINC=$(mysql_config --include | sed -e 's/^-I//g')
    export MYSQLLIBS=$(mysql_config --libs)
    export HOME=$TMPDIR
    export DESTBINDIR=$HOME/bin

    mkdir -p $HOME/lib $HOME/bin/x86_64

    cd ./src
    chmod +x ./checkUmask.sh
    ./checkUmask.sh

    make libs
    cd jkOwnLib
    make

    cp ../lib/x86_64/jkOwnLib.a $HOME/lib
    cp ../lib/x86_64/jkweb.a $HOME/lib
    cp -r ../inc  $HOME/

    cd ../utils
    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/inc
    cp $HOME/lib/jkOwnLib.a $out/lib
    cp $HOME/lib/jkweb.a $out/lib
    cp $HOME/bin/x86_64/* $out/bin
    cp -r $HOME/inc/* $out/inc/

    runHook postInstall
  '';

  meta = with lib; {
    description = "UCSC Genome Bioinformatics Group's suite of biological analysis tools, i.e. the kent utilities";
    homepage = "http://genome.ucsc.edu";
    changelog = "https://github.com/ucscGenomeBrowser/kent/releases/tag/v${version}_base";
    license = licenses.unfree;
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.linux;
  };
}
