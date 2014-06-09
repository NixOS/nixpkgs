{ stdenv, fetchurl, fetchgit, go }:

stdenv.mkDerivation rec {
  name = "syncthing-${version}";
  version = "0.8.11";

  src = fetchgit {
    url = "git://github.com/calmh/syncthing.git";
    rev = "refs/tags/v${version}";
    sha256 = "16dl9sqwhv0n1602pmi10d5j7z2196ijhvz4rfx7732210qbkpnn";
  };

  buildInputs = [ go ];

  patches = [ ./upnp.patch ];

  buildPhase = ''
    mkdir -p "./dependencies/src/github.com/calmh/syncthing"

    for a in auto buffers cid discover files lamport protocol scanner \
            logger beacon config xdr upnp model osutil versioner; do
        cp -r "./$a" "./dependencies/src/github.com/calmh/syncthing"
    done

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
