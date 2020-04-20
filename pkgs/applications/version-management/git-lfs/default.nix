{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-lfs";
  version = "2.10.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "1y5ryk0iz5g5sqaw79ml6fr5kvjgzcah481pk5qmnb2ipb1xlng9";
  };

  modSha256 = "1rvvgyg4gqbli4pwfnmyz59gf14k7925mdqj6ykp542gwnsjgjp2";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "Git extension for versioning large files";
    homepage    = "https://git-lfs.github.com/";
    license     = [ licenses.mit ];
    maintainers = [ maintainers.twey ];
  };
}
