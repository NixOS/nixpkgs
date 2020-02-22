{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "git-lfs";
  version = "2.8.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "17x9q4g1acf51bxr9lfmd2ym7w740n4ghdi0ncmma77kwabw9d3x";
  };

  goPackagePath = "github.com/git-lfs/git-lfs";

  subPackages = [ "." ];

  preBuild = ''
    cd go/src/${goPackagePath}
    go generate ./commands
  '';

  meta = with stdenv.lib; {
    description = "Git extension for versioning large files";
    homepage    = https://git-lfs.github.com/;
    license     = [ licenses.mit ];
    maintainers = [ maintainers.twey ];
  };
}
