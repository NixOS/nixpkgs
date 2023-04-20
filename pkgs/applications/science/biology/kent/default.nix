{ lib, stdenv
, libpng
, libuuid
, zlib
, bzip2
, xz
, openssl
, curl
, libmysqlclient
, bash
, fetchFromGitHub
, which
}:
stdenv.mkDerivation rec {
  pname = "kent";
  version = "446";

  src = fetchFromGitHub {
    owner = "ucscGenomeBrowser";
    repo = pname;
    rev = "v${version}_base";
    hash = "sha256-d8gcoyMwINdHoD6xaNKt4rCKrKir99+i4KIzJ2YnxRw=";
  };

  buildInputs = [ libpng libuuid zlib bzip2 xz openssl curl libmysqlclient ];

  patchPhase = ''
    runHook prePatch

    substituteInPlace ./src/checkUmask.sh \
      --replace "/bin/bash" "${bash}/bin/bash"

    substituteInPlace ./src/hg/sqlEnvTest.sh \
      --replace "which mysql_config" "${which}/bin/which ${libmysqlclient}/bin/mysql_config"

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    export MACHTYPE=$(uname -m)
    export CFLAGS="-fPIC"
    export MYSQLINC=$(mysql_config --include | sed -e 's/^-I//g')
    export MYSQLLIBS=$(mysql_config --libs)
    export DESTBINDIR=$NIX_BUILD_TOP/bin
    export HOME=$NIX_BUILD_TOP

    cd ./src
    chmod +x ./checkUmask.sh
    ./checkUmask.sh

    mkdir -p $NIX_BUILD_TOP/lib
    mkdir -p $NIX_BUILD_TOP/bin/x86_64

    make libs
    cd jkOwnLib
    make

    cp ../lib/x86_64/jkOwnLib.a $NIX_BUILD_TOP/lib
    cp ../lib/x86_64/jkweb.a $NIX_BUILD_TOP/lib

    cd ../utils
    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib
    cp $NIX_BUILD_TOP/lib/jkOwnLib.a $out/lib
    cp $NIX_BUILD_TOP/lib/jkweb.a $out/lib
    cp $NIX_BUILD_TOP/bin/x86_64/* $out/bin

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
