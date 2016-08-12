{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "git-lfs-${version}";
  # NOTE: use versions after 1.2.1
  version = "1.3.1";
  rev = "9c9dffb1b5baddfa06f280ef1b5fbf68ecbc90b1";
  
  goPackagePath = "github.com/github/git-lfs";

  src = fetchFromGitHub {
    inherit rev;
    owner = "github";
    repo = "git-lfs";
    sha256 = "0fg48jxh0gmd0w5yy3avascaasxk85019qayaikzfkym8bdqplb2";
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
