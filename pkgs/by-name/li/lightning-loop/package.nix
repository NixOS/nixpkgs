{
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGo127Module (finalAttrs: {
  pname = "lightning-loop";
  version = "0.35.4-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cin+0XGYkQxqXKn+vDb6SNz2NWs3MSuOPZz8oXN7uqw=";
  };

  vendorHash = "sha256-22jb50m0DDaXFkUSrbx+mv6SCAm3BWSp4/xhX0B57CM=";

  subPackages = [
    "cmd/loop"
    "cmd/loopd"
  ];

  env.CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    installManPage docs/loop.1
  '';

  meta = {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      proofofkeags
      starius
    ];
  };
})
