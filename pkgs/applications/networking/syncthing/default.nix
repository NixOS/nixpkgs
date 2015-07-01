{ stdenv, fetchurl, fetchgit, go }:

stdenv.mkDerivation rec {
  name = "syncthing-${version}";
  version = "0.11.11";

  src = fetchgit {
    url = "git://github.com/syncthing/syncthing.git";
    rev = "refs/tags/v${version}";
    sha256 = "1v1nf3m7gqnaw37fxgprn54904a4mx6j99whd8wcqs8hs70rdrw5";
  };

  buildInputs = [ go ];

  /*
  buildPhase = ''
    mkdir -p "src/github.com/syncthing/syncthing"
    mv * src/github.com/syncthing/syncthing
    export GOPATH=`pwd`/src
    cd src/github.com/syncthing/syncthing
    go run build.go -version v${version}
  '';
  */

  buildPhase = ''
    mkdir -p "./dependencies/src/github.com/syncthing/syncthing/internal"

    for a in `ls internal`; do
        cp -r "./internal/$a" "./dependencies/src/github.com/syncthing/syncthing/internal"
    done

    export GOPATH="`pwd`/Godeps/_workspace:`pwd`/dependencies"

    go test -cpu=1,2,4 ./...

    go run build.go -version v${version}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./bin $out
  '';

  meta = {
    homepage = http://syncthing.net/;
    description = "Replaces Dropbox and BitTorrent Sync with something open, trustworthy and decentralized";
    license = with stdenv.lib.licenses; mit;
    maintainers = with stdenv.lib.maintainers; [ matejc ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
