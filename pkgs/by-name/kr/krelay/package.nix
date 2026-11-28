{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "krelay";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "knight42";
    repo = "krelay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SEfloaqNPXlvNm3xQXJWzgWbL6V3lb27ua/7WjGdkIk=";
  };

  vendorHash = "sha256-55wT7jMZyDJs8FKl23/OIlyQgfiXVhjrOVjeYyVunFI=";

  subPackages = [ "cmd/client" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/knight42/krelay/pkg/constants.ClientVersion=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/client $out/bin/kubectl-relay
  '';

  meta = {
    description = "Drop-in replacement for `kubectl port-forward` with some enhanced features";
    homepage = "https://github.com/knight42/krelay";
    changelog = "https://github.com/knight42/krelay/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ivankovnatsky ];
    mainProgram = "kubectl-relay";
  };
})
