{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "routedns";
  version = "0.1.153";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "routedns";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EkYhZ4c1eTslubEYXA6mV+bV+s2+jQ3alLy1nXq29/o=";
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
