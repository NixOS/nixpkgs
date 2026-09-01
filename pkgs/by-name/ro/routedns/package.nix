{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "routedns";
  version = "0.1.250";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "routedns";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jFJLgL1V1L+AcQayWdBwBUh0OmI1KJwD84cEpxKPoXw=";
  };

  vendorHash = "sha256-w8rZue6/cc8wg40Ey+P216cQGhbCznjSsLi1G4YfRsI=";

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
