{ stdenv, fetchurl, fetchgit, go }:

stdenv.mkDerivation rec {
  name = "syncthing-${version}";
  version = "0.10.30";

  src = fetchgit {
    url = "git://github.com/syncthing/syncthing.git";
    rev = "refs/tags/v${version}";
    sha256 = "0sjhr9agsi4fwshm75qq1vrlfq6cgkladdk6wyjy11bcb114smdx";
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
