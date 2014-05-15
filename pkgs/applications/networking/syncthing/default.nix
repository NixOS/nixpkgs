{ stdenv, fetchurl, fetchgit, go }:

stdenv.mkDerivation rec {
  name = "syncthing-${version}";
  version = "0.8.5";

  src = fetchgit {
    url = "git://github.com/calmh/syncthing.git";
    rev = "refs/tags/v${version}";
    sha256 = "0525fvar5c22sxg7737ajny80srds1adhi73a8yr12wsjnsqfi6x";
  };

  buildInputs = [ go ];

  buildPhase = ''
    mkdir -p "./dependencies/src/github.com/calmh/syncthing"

    cp -r "./auto" "./dependencies/src/github.com/calmh/syncthing"
    cp -r "./buffers" "./dependencies/src/github.com/calmh/syncthing"
    cp -r "./cid" "./dependencies/src/github.com/calmh/syncthing"
    cp -r "./discover" "./dependencies/src/github.com/calmh/syncthing"
    cp -r "./files" "./dependencies/src/github.com/calmh/syncthing"
    cp -r "./lamport" "./dependencies/src/github.com/calmh/syncthing"
    cp -r "./protocol" "./dependencies/src/github.com/calmh/syncthing"
    cp -r "./scanner" "./dependencies/src/github.com/calmh/syncthing"
    cp -r "./mc" "./dependencies/src/github.com/calmh/syncthing"
    cp -r "./xdr" "./dependencies/src/github.com/calmh/syncthing"
    cp -r "./upnp" "./dependencies/src/github.com/calmh/syncthing"

    export GOPATH="`pwd`/Godeps/_workspace:`pwd`/dependencies"

    go test -cpu=1,2,4 ./...

    mkdir ./bin

    go build -o ./bin/syncthing -ldflags "-w -X main.Version v${version}" ./cmd/syncthing
    go build -o ./bin/stcli -ldflags "-w -X main.Version v${version}" ./cmd/stcli
  '';

  installPhase = ''
    ensureDir $out/bin
    cp -r ./bin $out
  '';

  meta = {
    homepage = http://syncthing.net/;
    description = "Syncthing replaces Dropbox and BitTorrent Sync with something open, trustworthy and decentralized";
    license = with stdenv.lib.licenses; mit;
    maintainers = with stdenv.lib.maintainers; [ matejc ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
