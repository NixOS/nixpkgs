{
  git,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "golink";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "golink";
    tag = "v${version}";
    hash = "sha256-cIml0ewF5j2cQySLHkMmV1rl7cVH8wuoPFeFDCARi1A=";
  };

  vendorHash = "sha256-QIAkmqXWH3X2dIoWyVcqFXVHBwzyv1dNPfdkzD5LuSE=";

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

  meta = with lib; {
    description = "Private shortlink service for tailnets";
    homepage = "https://github.com/tailscale/golink";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "golink";
  };
}
