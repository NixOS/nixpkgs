{ lib, fetchgit, goPackages }:

with goPackages;

buildGoPackage rec {
  name = "syncthing-${version}";
  version = "0.11.1";
  goPackagePath = "github.com/syncthing/syncthing";
  src = fetchgit {
    url = "git://github.com/syncthing/syncthing.git";
    rev = "refs/tags/v${version}";
    sha256 = "518add39e2239fc8575cdf5cafc3562f006df7201fbd272077ed3bbbbfd816d4";
  };

  subPackages = [ "cmd/syncthing" ];

  buildFlagsArray = "-ldflags=-w -X main.Version v${version}";

  preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace";

  doCheck = true;

  dontInstallSrc = true;

  meta = {
    homepage = http://syncthing.net/;
    description = "Replaces Dropbox and BitTorrent Sync with something open, trustworthy and decentralized";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ matejc ];
    platforms = with lib.platforms; unix;
  };
}
