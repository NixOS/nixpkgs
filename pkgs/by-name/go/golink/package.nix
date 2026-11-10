{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "golink";
  version = "1.0.0-unstable-2026-10-27";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "golink";
    rev = "d02fb073fd1cb92f034aee40f1d3c6c846fecff1";
    hash = "sha256-C0lov54z1bhkylLn/PnGV7kA/wq2c0cb+F4x2ZAJdgI=";
  };

  vendorHash = "sha256-eOQSpWazd6OoGxIKRfdzt/BG8LfnOPBoj2nTQD+FhOk=";

  overrideModAttrs = old: {
    # netdb.go allows /etc/protocols and /etc/services to not exist and happily proceeds, but it panic()s if they exist but return permission denied.
    postBuild = ''
      patch -p0 < ${./darwin-sandbox-fix.patch}
    '';
  };

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Private shortlink service for tailnets";
    homepage = "https://github.com/tailscale/golink";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "golink";
  };
}
