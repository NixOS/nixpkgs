{ lib, fetchgit, goPackages }:

with goPackages;

buildGoPackage rec {
  name = "syncthing-${version}";
  version = "0.11.7";
  goPackagePath = "github.com/syncthing/syncthing";
  src = fetchgit {
    url = "git://github.com/syncthing/syncthing.git";
    rev = "refs/tags/v${version}";
    sha256 = "7d928a255c61c7b89d460cc70c79bd8e85bef3e919c157f59d5709fef4153c8d";
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
