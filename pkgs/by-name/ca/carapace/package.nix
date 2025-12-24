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
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gYgROZAmhgU/H4XsFXdIHRrS72EVRHxAalx8K7hmnDE=";
  };

  vendorHash = "sha256-4k9iX47PjEEsJO1lB7xOwCnakhkd+OelaAr/zv3A1l8=";

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
