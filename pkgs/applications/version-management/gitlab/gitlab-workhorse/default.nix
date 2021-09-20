{ lib, fetchFromGitLab, git, buildGoModule }:
let
  data = (builtins.fromJSON (builtins.readFile ../data.json));
in
buildGoModule rec {
  pname = "gitlab-workhorse";

  version = "14.2.4";

  src = fetchFromGitLab {
    owner = data.owner;
    repo = data.repo;
    rev = data.rev;
    sha256 = data.repo_hash;
  };

  sourceRoot = "source/workhorse";

  vendorSha256 = "sha256-q0LuXmjoO6mjVZpMRVVGL862mA+MaCejTCx99Zi5VEI=";
  buildInputs = [ git ];
  ldflags = [ "-X main.Version=${version}" ];
  doCheck = false;

  meta = with lib; {
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin talyz ];
    license = licenses.mit;
  };
}
