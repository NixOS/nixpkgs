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

  version = "19.3.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = data.owner;
    repo = data.repo;
    rev = data.rev;
    sha256 = data.repo_hash;
  };

  sourceRoot = "${finalAttrs.src.name}/workhorse";

  vendorHash = "sha256-kF0ne1zMBDjCWYZ31AVXP1rVbDGimEVWhfnjUdHRXEI=";
  buildInputs = [ git ];
  ldflags = [ "-X main.Version=${finalAttrs.version}" ];
  doCheck = false;
  prodyVendor = true;

  meta = {
    homepage = "http://www.gitlab.com/";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.gitlab ];
    license = lib.licenses.mit;
  };
})
