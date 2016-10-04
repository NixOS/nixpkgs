{ stdenv, lib, go, fetchgit, git }:

stdenv.mkDerivation rec {
  version = "0.9";
  name = "camlistore-${version}";

  src = fetchgit {
    url = "https://github.com/camlistore/camlistore";
    rev = "7b78c50007780643798adf3fee4c84f3a10154c9";
    sha256 = "1vc4ca2rn8da0z0viv3vv2p8z211zdvq83jh2x2izdckdz204n17";
    leaveDotGit = true;
  };

  buildInputs = [ go git ];

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
