{ lib, fetchgit, goPackages }:

with goPackages;

buildGoPackage rec {
  name = "syncthing-${version}";
  version = "0.11.21";
  goPackagePath = "github.com/syncthing/syncthing";
  src = fetchgit {
    url = "git://github.com/syncthing/syncthing.git";
    rev = "refs/tags/v${version}";
    sha256 = "2e7faf1002570a64ef76c6bbdde781c550db6c45b30f4fa1c394102809cad977";
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
