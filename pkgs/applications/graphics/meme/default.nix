{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "meme-unstable-${version}";
  version = "2017-09-10";

  owner = "nomad-software";
  repo = "meme";
  goPackagePath = "github.com/${owner}/${repo}";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "a6521f2eecb0aac22937b0013747ed9cb40b81ea";
    sha256 = "1gbsv1d58ck6mj89q31s5b0ppw51ab76yqgz39jgwqnkidvzdfly";
  };

  meta = with stdenv.lib; {
    description = "A command line utility for creating image macro style memes";
    homepage = https://github.com/nomad-software/meme;
    license = licenses.mit;
    maintainers = [ maintainers.fgaz ];
    platforms = with platforms; linux ++ darwin;
  };
}
