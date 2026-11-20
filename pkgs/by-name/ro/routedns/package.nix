{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "routedns";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "routedns";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Mx7qbGp1K7ErStlivD+/24qU7QLNk52QJdmQvUQo7Gw=";
  };

  vendorHash = "sha256-8yMzPHU/Xmx+fVmTTFx+A70UT9KnfOUYUMIZ570Elyg=";

  subPackages = [ "./cmd/routedns" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/folbricht/routedns.BuildVersion=v${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/folbricht/routedns";
    description = "DNS stub resolver, proxy and router";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jsimonetti ];
    mainProgram = "routedns";
  };
})
