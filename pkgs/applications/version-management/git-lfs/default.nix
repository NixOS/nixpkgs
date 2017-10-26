{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "git-lfs-${version}";
  version = "2.3.4";

  goPackagePath = "github.com/git-lfs/git-lfs";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "0fv1ly9577jrjwx91jqfql740rwp06chl4y37pcpl72nc08jvcw7";
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
