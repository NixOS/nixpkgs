{
  lib,
  fetchFromGitLab,
  git,
  buildGoModule,
}:
let
  data = lib.importJSON ../data.json;
in
buildGoModule (finalAttrs: {
  pname = "gitlab-workhorse";

  version = "18.11.6";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = data.owner;
    repo = data.repo;
    rev = data.rev;
    sha256 = data.repo_hash;
  };

  sourceRoot = "${finalAttrs.src.name}/workhorse";

  vendorHash = "sha256-6/50YxOW3NK5qzy0ALERCMK3JpLJflnw8ePAvNXANxQ=";

  buildInputs = [ git ];
  ldflags = [ "-X main.Version=${finalAttrs.version}" ];
  doCheck = false;
  proxyVendor = true;

  meta = {
    homepage = "http://www.gitlab.com/";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.gitlab ];
    license = lib.licenses.mit;
  };
})
