{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "git-lfs-${version}";
  version = "2.4.2";

  goPackagePath = "github.com/git-lfs/git-lfs";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "0ww1jh45nlm74vbi4n6cdxi35bzgjlqmz3q8h9igdwfhkf79kd5c";
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
