{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "git-lfs";
  version = "2.7.2";

  goPackagePath = "github.com/git-lfs/git-lfs";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "1nf40rbdz901vsahg5cm09pznpina6wimmxl0lmh8pn0mi51yzvc";
  };

  preBuild = ''
    pushd go/src/github.com/git-lfs/git-lfs
    go generate ./commands
    popd
  '';

  postInstall = ''
    rm -v $bin/bin/{man,script,cmd}
  '';

  meta = with stdenv.lib; {
    description = "Git extension for versioning large files";
    homepage    = https://git-lfs.github.com/;
    license     = [ licenses.mit ];
    maintainers = [ maintainers.twey ];
  };
}
