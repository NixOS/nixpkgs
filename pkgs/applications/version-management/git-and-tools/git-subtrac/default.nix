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

  modSha256 = "147vzllp1gydk2156hif313vwykagrj35vaiqy1swqczxs7p9hhs";

  meta = with lib; {
    description = "Keep the content for your git submodules all in one place: the parent repo";
    homepage = "https://github.com/apenwarr/git-subtrac";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
