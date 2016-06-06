{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "git-lfs-${version}";
  version = "1.2.0";
  rev = "v${version}";
  
  goPackagePath = "github.com/github/git-lfs";

  src = fetchFromGitHub {
    inherit rev;
    owner = "github";
    repo = "git-lfs";
    sha256 = "0z8giavcvfpzmhnxxsqvsgabjfq5gpka8jy4qvadf60yibxds9fp";
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
