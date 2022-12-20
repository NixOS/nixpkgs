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
, fetchpatch
}:
stdenv.mkDerivation rec {
  pname = "kent";
  version = "404";

  src = fetchFromGitHub {
    owner = "ucscGenomeBrowser";
    repo = pname;
    rev = "v${version}_base";
    sha256 = "0l5lmqqc6sqkf4hyk3z4825ly0vdlj5xdfad6zd0708cb1v81nbx";
  };

  buildInputs = [ libpng libuuid zlib bzip2 xz openssl curl libmysqlclient ];

  prePatch = ''
    substituteInPlace ./src/checkUmask.sh \
      --replace "/bin/bash" "${bash}/bin/bash"

    substituteInPlace ./src/hg/sqlEnvTest.sh \
      --replace "which mysql_config" "${which}/bin/which ${libmysqlclient}/bin/mysql_config"

  '';
  patches = [(fetchpatch { url = "https://github.com/ucscGenomeBrowser/kent/commit/316e4fd40f53c96850128fd65097a42623d1e736.patch"; sha256 = "sha256-wr3NP5qoSonKz1TLKtQyrTPErCOk2gC1RimcX0tE7cM="; })];

  buildPhase = ''
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
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp $NIX_BUILD_TOP/lib/jkOwnLib.a $out/lib
    cp $NIX_BUILD_TOP/lib/jkweb.a $out/lib
    cp $NIX_BUILD_TOP/bin/x86_64/* $out/bin
  '';

  meta = with lib; {
    description = "UCSC Genome Bioinformatics Group's suite of biological analysis tools, i.e. the kent utilities";
    license = licenses.unfree;
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.linux;
  };
}
