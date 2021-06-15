{ lib, fetchFromGitLab, git, buildGoModule }:
let
  data = (builtins.fromJSON (builtins.readFile ../data.json));
in
buildGoModule rec {
  pname = "gitlab-workhorse";

  version = "13.12.4";

  src = fetchFromGitLab {
    owner = data.owner;
    repo = data.repo;
    rev = data.rev;
    sha256 = data.repo_hash;
  };

  sourceRoot = "source/workhorse";

  vendorSha256 = "sha256-JJN1KqqbP4fIW/k6LebIaWdYOmIzHqxCDgOKrkbB7Nw=";
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
