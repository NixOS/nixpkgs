{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "routedns";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "routedns";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hutpyaFdtHlBcADDAghnYl9IgQ986OTc1y6Tv+vcV+Y=";
  };

  vendorHash = "sha256-25UOMNZGUstFBhdx9/ROe42Pp/ReHiwFRZF4YlyzcZg=";

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
