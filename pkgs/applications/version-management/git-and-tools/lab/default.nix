{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lab-${version}";
  version = "0.14.0";

  goPackagePath = "github.com/zaquestion/lab";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "zaquestion";
    repo = "lab";
    rev = "v${version}";
    sha256 = "0dqahzm721kpps4i33qgk78y982n8gj5afpk73qyzbraf5y3cw92";
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
