{ stdenv, lib, go, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.8";
  name = "camlistore-${version}";

  src = fetchurl {
    url = "https://github.com/bradfitz/camlistore/archive/${version}.tar.gz";
    sha256 = "03y5zs4i9lx93apqqqfgmbxamk06z3w1q763qp0lvb15mq45gdv1";
  };

  buildInputs = [ go ];

  buildPhase = ''
    go run make.go
    rm bin/README
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A way of storing, syncing, sharing, modelling and backing up content";
    homepage = https://camlistore.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}
