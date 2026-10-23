{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "golink";
  version = "1.0.0-unstable-2026-07-03";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "golink";
    rev = "30223ca66c2dad29356b6266254e1bf4af921f28";
    hash = "sha256-hp886p94NHA8u3021horHFf6tGa8x8gWdeNA1XnQZ6E=";
  };

  vendorHash = "sha256-7Ykb2YPrHwwBrWuufFwGTT9mQFzIRkiBiNlLvqpr+wo=";

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
