{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "git-lfs-${version}";
  # NOTE: use versions after 1.2.1
  version = "2016-06-07";
  rev = "12fe249f2eebb56608a825fdb4a68c00f090bc91";
  
  goPackagePath = "github.com/github/git-lfs";

  src = fetchFromGitHub {
    inherit rev;
    owner = "github";
    repo = "git-lfs";
    sha256 = "0cj7xbgvj706r1cyxqlcwfvy5zg2d19al04d441sxa6spr6xa4v6";
  };

  # Tests fail with 'lfstest-gitserver.go:46: main redeclared in this block'
  excludedPackages = [ "test" ];

  preBuild = ''
    pushd go/src/github.com/github/git-lfs
      go generate ./commands
    popd
  '';

  postInstall = ''
    rm -v $bin/bin/{man,script}
  '';
}
