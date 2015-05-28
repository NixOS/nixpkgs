{ lib, fetchgit, goPackages }:

with goPackages;

buildGoPackage rec {
  name = "syncthing-${version}";
  version = "0.11.6";
  goPackagePath = "github.com/syncthing/syncthing";
  src = fetchgit {
    url = "git://github.com/syncthing/syncthing.git";
    rev = "refs/tags/v${version}";
    sha256 = "7fe7d7034c0e502036e2a0bb1b94b1701bd194cc82f07495da8a41c4b097c6a3";
  };

  subPackages = [ "cmd/syncthing" ];

  buildFlagsArray = "-ldflags=-w -X main.Version v${version}";

  preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace";

  doCheck = true;

  dontInstallSrc = true;

  meta = {
    homepage = http://syncthing.net/;
    description = "Replaces Dropbox and BitTorrent Sync with something open, trustworthy and decentralized";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matejc ];
    platforms = with lib.platforms; unix;
  };
}
