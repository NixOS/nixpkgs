{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "git-lfs-${version}";
  version = "1.5.6";
  rev = "0d02fb7d9a1c599bbf8c55e146e2845a908e04e0";
  
  goPackagePath = "github.com/git-lfs/git-lfs";

  src = fetchFromGitHub {
    inherit rev;
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "0wddry1lqjccf4522fvhx6grx8h57xsz17lkaf5aybnrgw677w3d";
  };

  # Tests fail with 'lfstest-gitserver.go:46: main redeclared in this block'
  excludedPackages = [ "test" ];

  preBuild = ''
    pushd go/src/github.com/git-lfs/git-lfs
      go generate ./commands
    popd
  '';

  postInstall = ''
    rm -v $bin/bin/{man,script}
  '';
  meta = with stdenv.lib; {
    description = "Git extension for versioning large files";
    homepage    = https://git-lfs.github.com/;
    license     = [ licenses.mit ];
    maintainers = [ maintainers.twey ];
  };
}
