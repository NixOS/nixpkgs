{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-subtrac";
  version = "0.02";

  src = fetchFromGitHub {
    owner = "apenwarr";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nj950r38sxzrgw69m1xphm7a4km2g29iw2897gfx4wx57jl957k";
  };

  vendorSha256 = "1ccwbhzwys8sl3m2rs2lp70snzsi2a0ahnnq8kn15rrlvsv5qahf";

  meta = with lib; {
    description = "Keep the content for your git submodules all in one place: the parent repo";
    homepage = "https://github.com/apenwarr/git-subtrac";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}