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
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BdXQGFqqcsOmPvM9kf+lwXKQkmT6Jr4jua5ivovTVZg=";
  };

  vendorHash = "sha256-Kc5kecKPUOPK6bTnFxe9gtey5LobK8h0hgkJEENI7ek=";

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
