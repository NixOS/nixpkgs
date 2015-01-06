{ stdenv, fetchgit, go }:

stdenv.mkDerivation rec {
  name = "syncthing-${version}";
  version = "0.10.17";

  src = fetchgit {
    url = "git://github.com/syncthing/syncthing.git";
    rev = "refs/tags/v${version}";
    sha256 = "1hv0va7234rgyahn8xvpyj1bsbmn7ifsyqm7b3ghhybinclghp1w";
  };

  buildInputs = [ go ];

  patches = [
    # Remove when Go 1.4 is available in Nix, or when this pull request is released:
    # https://github.com/syncthing/syncthing/pull/1183
    ./fix-go-1.4-range.patch
  ];

  buildPhase = ''
    mkdir -p "./dependencies/src/github.com/syncthing/syncthing"
    cp -r internal "./dependencies/src/github.com/syncthing/syncthing"

    export GOPATH="`pwd`/Godeps/_workspace:`pwd`/dependencies"

    # Tests can't be run in parallel because TestPredictableRandom relies on global state
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
