{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "git-lfs-${version}";
  version = "2.2.1";
  rev = "621d1f821f73efcedc829dda43fd9c1fcf07c6ab";

  goPackagePath = "github.com/git-lfs/git-lfs";

  src = fetchFromGitHub {
    inherit rev;
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "00wc4gjs4yy2qld1m4yar37jkw9fdi2h8xp25hy2y80cnyiafn7s";
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
