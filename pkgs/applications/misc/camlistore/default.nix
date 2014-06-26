{ stdenv, lib, go, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.7";
  name = "camlistore-${version}";

  src = fetchurl {
    url = "https://github.com/bradfitz/camlistore/archive/0.7.tar.gz";
    sha256 = "0lc35x2b9llrnma0m5czivly0c3l4lh3ldw9hwn83lkh8n0bzn11";
  };

  buildInputs = [ go ];

  buildPhase = ''
    go run make.go
    rm bin/README
  '';

  installPhase = ''
    ensureDir $out/bin
    cp bin/* $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Camlistore is a way of storing, syncing, sharing, modelling and backing up content";
    homepage = https://camlistore.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}
