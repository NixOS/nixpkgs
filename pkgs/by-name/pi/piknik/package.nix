{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  piknik,
}:

buildGoModule (finalAttrs: {
  pname = "piknik";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "piknik";
    rev = finalAttrs.version;
    hash = "sha256-Kdqh3sQuO0iT0RW2hU+nrmBltxCFiqOSL00cbDHZJjc=";
  };

  vendorHash = "sha256-t7w8uKYda6gT08ymAJqS38JgY70kuKNkQvjHFK91j8s=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = piknik;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Copy/paste anything over the network";
    homepage = "https://github.com/jedisct1/piknik";
    changelog = "https://github.com/jedisct1/piknik/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "piknik";
  };
})
