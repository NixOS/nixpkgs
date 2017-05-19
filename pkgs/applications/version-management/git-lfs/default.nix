{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "git-lfs-${version}";
  version = "2.0.2";
  rev = "85e2aec4d949517b4a7a53e4f745689331952b6c";

  goPackagePath = "github.com/git-lfs/git-lfs";

  src = fetchFromGitHub {
    inherit rev;
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "0cvs17rd4qgaqj9vz6pwx9y3ni8c99gzykc3as92x37962nmq5cy";
  };

  preBuild = ''
    pushd go/src/github.com/git-lfs/git-lfs
    go generate ./commands
    popd
  '';

  postInstall = ''
    rm -v $bin/bin/{man,script,genmakefile}
  '';

  meta = with stdenv.lib; {
    description = "Git extension for versioning large files";
    homepage    = https://git-lfs.github.com/;
    license     = [ licenses.mit ];
    maintainers = [ maintainers.twey ];
  };
}
