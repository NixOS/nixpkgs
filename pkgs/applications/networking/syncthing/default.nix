{ lib, fetchgit, goPackages }:

with goPackages;

buildGoPackage rec {
  name = "syncthing-${version}";
  version = "0.11.10";
  goPackagePath = "github.com/syncthing/syncthing";
  src = fetchgit {
    url = "git://github.com/syncthing/syncthing.git";
    rev = "refs/tags/v${version}";
    sha256 = "f8260d17519ff71232ab60551b444c0138d3391426ab2ef7f9f8e4d2fdac7c40";
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
    maintainers = with lib.maintainers; [ matejc theuni ];
    platforms = with lib.platforms; unix;
  };
}
