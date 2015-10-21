{ stdenv, fetchgit, git, go }:

stdenv.mkDerivation rec {
  version = "0.2.14";
  name = "gitlab-git-http-server-${version}";

  srcs = fetchgit {
    url = "https://gitlab.com/gitlab-org/gitlab-git-http-server.git";
    rev = "7c63f08f7051348e56b903fc0bbefcfed398fc1c";
    sha256 = "557d63a90c61371598b971a06bc056993610b58c2ef5762d9ef145ec2fdada78";
  };

  buildInputs = [ git go ];

  buildPhase = ''
    make PREFIX=$out
  '';

  installPhase = ''
    mkdir -p $out/bin
    make install PREFIX=$out
  '';
}
