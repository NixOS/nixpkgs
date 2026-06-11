{
  lib,
  git,
  buildGoModule,
  gitlab,
}:

buildGoModule (finalAttrs: {
  pname = "gitlab-workhorse";

  version = gitlab.passthru.GITLAB_WORKHORSE_VERSION;

  strictDeps = true;
  __structuredAttrs = true;

  # nixpkgs-update: no auto update
  src = gitlab.src;

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
