{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  carapace,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "carapace";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k6fWtwDTNc2qcr9ryL7wMVy744fiP8NrLqm4crVr+EI=";
  };

  vendorHash = "sha256-5AqoM16M5pPfRYxqa72LrHJRRatK2qnZK3pQIoFXG9g=";

  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "./cmd/carapace" ];

  tags = [ "release" ];

  preBuild = ''
    GOOS= GOARCH= go generate ./...
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests.version = testers.testVersion { package = carapace; };

  meta = {
    description = "Multi-shell multi-command argument completer";
    homepage = "https://carapace.sh/";
    maintainers = with lib.maintainers; [ mimame ];
    license = lib.licenses.mit;
    mainProgram = "carapace";
  };
})
