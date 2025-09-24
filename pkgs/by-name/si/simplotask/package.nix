{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "simplotask";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "spot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zu7GkvNVhf6TeZg2AVH8GTi5ORK5aUspSvB1ThOBwTo=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s -w"
    "-X main.revision=v${finalAttrs.version}"
  ];

  doCheck = false;

  postInstall = ''
    mv $out/bin/{secrets,spot-secrets}
    installManPage *.1
  '';

  meta = {
    description = "Tool for effortless deployment and configuration management";
    homepage = "https://spot.umputun.dev/";
    maintainers = with lib.maintainers; [ sikmir ];
    license = lib.licenses.mit;
    mainProgram = "spot";
  };
})
