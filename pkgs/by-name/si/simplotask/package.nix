{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "simplotask";
  version = "1.19.3";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "spot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XtM9WiLZ8KqaG7oQBADRRz//o60EBFEZl/pgCLQ+adM=";
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
