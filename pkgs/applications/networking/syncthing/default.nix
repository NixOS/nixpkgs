{ stdenv, fetchgit, go }:

stdenv.mkDerivation rec {
  name = "syncthing-${version}";
  version = "0.10.19";

  src = fetchgit {
    url = "git://github.com/syncthing/syncthing.git";
    rev = "refs/tags/v${version}";
    sha256 = "e89d618ddbcbab2a4c6d0430b98e792a1780ebd40c19ee6f4644df2fdeea0601";
  };

  buildInputs = [ go ];

  buildPhase = ''
    mkdir -p "./dependencies/src/github.com/syncthing/syncthing"
    cp -r internal "./dependencies/src/github.com/syncthing/syncthing"

    export GOPATH="`pwd`/Godeps/_workspace:`pwd`/dependencies"

    go run build.go test

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
