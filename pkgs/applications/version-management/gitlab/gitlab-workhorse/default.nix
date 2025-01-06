{ lib, fetchFromGitLab, git, buildGoModule }:
let
  data = lib.importJSON ../data.json;
in
buildGoModule rec {
  pname = "gitlab-workhorse";

  version = "17.6.2";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = data.owner;
    repo = data.repo;
    rev = data.rev;
    sha256 = data.repo_hash;
  };

  sourceRoot = "${src.name}/workhorse";

  vendorHash = "sha256-ir2Npjl39K2DzjT8fnbOOcMmfHiwFnVmvG04oh2GoOA=";
  buildInputs = [ git ];
  ldflags = [ "-X main.Version=${version}" ];
  doCheck = false;
  prodyVendor = true;

  meta = with lib; {
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = teams.gitlab.members;
    license = licenses.mit;
  };
}
