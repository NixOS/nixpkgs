{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "git-lfs-${version}";
  version = "2.5.2";

  goPackagePath = "github.com/git-lfs/git-lfs";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "1y9l35j59d422v9hsbi117anm5d0177nspiy9r2zbjz3ygd9a4ck";
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
