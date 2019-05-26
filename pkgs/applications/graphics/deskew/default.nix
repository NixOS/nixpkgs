{ stdenv, fetchFromBitbucket, libtiff, fpc }:

stdenv.mkDerivation rec {

  name = "deskew-${version}";
  version = "1.25";

  src = fetchFromBitbucket {
    owner = "galfar";
    repo = "app-deskew";
    rev = "v${version}";
    sha256 = "0zjjj66qhgqkmfxl3q7p78dv4xl4ci918pgl4d5259pqdj1bfgc8";
  };

  nativeBuildInputs = [ fpc ];
  buildInputs = [ libtiff ];

  buildPhase = ''
    rm -r Bin # Remove pre-compiled binary
    mkdir Bin
    chmod +x compile.sh
    ./compile.sh
  '';

  installPhase = ''
    install -Dt $out/bin Bin/*
  '';

  meta = with stdenv.lib; {
    description = "A command line tool for deskewing scanned text documents";
    homepage = https://bitbucket.org/galfar/app-deskew/overview;
    license = licenses.mit;
    maintainers = with maintainers; [ryantm];
    platforms = platforms.all;
  };

}
