{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "routedns";
  version = "0.1.169";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "routedns";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VQ+8wGv46YZbCYedU1gYTNqd54+kjbuPKbaYRV3IHYc=";
  };

  vendorHash = "sha256-a4KcKb75yWv7+1vIYCypS9nnrFJ3zogXIPzUVVA7AXs=";

  subPackages = [ "./cmd/routedns" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/folbricht/routedns";
    description = "DNS stub resolver, proxy and router";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jsimonetti ];
    mainProgram = "routedns";
  };
})
