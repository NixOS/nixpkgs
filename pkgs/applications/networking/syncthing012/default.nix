{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "syncthing-${version}";
  version = "0.12.15";
  rev = "v${version}";

  buildFlags = "--tags noupgrade,release";
  
  goPackagePath = "github.com/syncthing/syncthing";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/syncthing/syncthing";
    sha256 = "108w7gvm3nbbsgp3h5p84fj4ba0siaz932i7yyryly486gzvpm43";
  };

  goDeps = ./deps.json;

  postPatch = ''
    # Mostly a cosmetic change
    sed -i 's,unknown-dev,${version},g' cmd/syncthing/main.go
  '';
}
