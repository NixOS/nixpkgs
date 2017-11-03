{ stdenv, lib, go, fetchgit, git, buildGoPackage }:

buildGoPackage rec {
  name = "camlistore-${version}";
  version = "0.9";

  src = fetchgit {
    url = "https://github.com/camlistore/camlistore";
    rev = "refs/tags/${version}";
    sha256 = "1ypplr939ny9drsdngapa029fgak0wic8sbna588m79cbl17psya";
    leaveDotGit = true;
  };

  buildInputs = [ git ];

  goPackagePath = "";
  buildPhase = ''
    cd go/src/camlistore
    go run make.go
  '';

  installPhase = ''
    mkdir -p $bin/bin
    rm bin/README
    cp bin/* $bin/bin
  '';

  meta = with stdenv.lib; {
    description = "A way of storing, syncing, sharing, modelling and backing up content";
    homepage = https://camlistore.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}
