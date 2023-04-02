{ lib, fetchFromGitLab, git, buildGoModule }:
let
  data = lib.importJSON ../data.json;
in
buildGoModule rec {
  pname = "gitlab-workhorse";

  version = "15.10.1";

  src = fetchFromGitLab {
    owner = data.owner;
    repo = data.repo;
    rev = data.rev;
    sha256 = data.repo_hash;
  };

  sourceRoot = "source/workhorse";

  vendorSha256 = "sha256-HG/QobU1LsFhbNF4lNq9tLwjcLD2l3TXnsJ+tjqc0Q8=";
  buildInputs = [ git ];
  ldflags = [ "-X main.Version=${version}" ];
  doCheck = false;

  meta = with lib; {
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin talyz yayayayaka ];
    license = licenses.mit;
  };
}
