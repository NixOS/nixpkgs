{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "git-lfs-${version}";
  version = "2.3.3";
  rev = "c9d3beb098254f067680a5ccbb8742387f81d82e";

  goPackagePath = "github.com/git-lfs/git-lfs";

  src = fetchFromGitHub {
    inherit rev;
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "1hzpzbm46f45vh5liijpyppfcmr7wycnsa09vmilq0wm341ivnsf";
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
