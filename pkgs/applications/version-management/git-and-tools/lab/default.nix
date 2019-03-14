{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lab-${version}";
  version = "0.15.2";

  goPackagePath = "github.com/zaquestion/lab";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "zaquestion";
    repo = "lab";
    rev = "v${version}";
    sha256 = "1210cf6ss4ivm2jxq3k3c34vpra02pl91fpmvqbvw5sm53j7xfaf";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Lab wraps Git or Hub, making it simple to clone, fork, and interact with repositories on GitLab";
    homepage = https://zaquestion.github.io/lab;
    license = licenses.unlicense;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
