{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-subtrac";
  version = "0.03";

  src = fetchFromGitHub {
    owner = "apenwarr";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ky04h18vg1yl9lykbhkmf25qslg0z2qzziy8c7afmvzvvvhm2v5";
  };

  vendorSha256 = "1ccwbhzwys8sl3m2rs2lp70snzsi2a0ahnnq8kn15rrlvsv5qahf";

  meta = with lib; {
    description = "Keep the content for your git submodules all in one place: the parent repo";
    homepage = "https://github.com/apenwarr/git-subtrac";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
