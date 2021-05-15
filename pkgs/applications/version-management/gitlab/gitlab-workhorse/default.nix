{ lib, fetchFromGitLab, git, buildGoModule }:
let
  data = (builtins.fromJSON (builtins.readFile ../data.json));
in
buildGoModule rec {
  pname = "gitlab-workhorse";

  version = "13.11.2";

  src = fetchFromGitLab {
    owner = data.owner;
    repo = data.repo;
    rev = data.rev;
    sha256 = data.repo_hash;
  };

  sourceRoot = "source/workhorse";

  vendorSha256 = "sha256-m/Mx4Nr4tPK6yfcHxAFbjh9DI/1WnKReaaylWpNSrc8=";
  buildInputs = [ git ];
  buildFlagsArray = "-ldflags=-X main.Version=${version}";
  doCheck = false;

  meta = with lib; {
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin talyz ];
    license = licenses.mit;
  };
}
