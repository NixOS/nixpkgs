{ stdenv, fetchurl, fetchgit, go }:

stdenv.mkDerivation rec {
  name = "syncthing-${version}";
  version = "0.10.11";

  src = fetchgit {
    url = "git://github.com/syncthing/syncthing.git";
    rev = "refs/tags/v${version}";
    sha256 = "1w86h5jxa1jf083vpbp6bwj0y1k1m7zj4vq58mwzmd48ixn6s4fy";
  };

  buildInputs = [ go ];

  buildPhase = ''
    mkdir -p "./dependencies/src/github.com/syncthing/syncthing"

    for a in internal ; do
        cp -r "./$a" "./dependencies/src/github.com/syncthing/syncthing"
    done

    export GOPATH="`pwd`/Godeps/_workspace:`pwd`/dependencies"

    #go test -cpu=1,2,4 ./...

    mkdir ./bin

    go build -o ./bin/syncthing -ldflags "-w -X main.Version v${version}" ./cmd/syncthing
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
