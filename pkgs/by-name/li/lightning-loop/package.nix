{
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGo127Module (finalAttrs: {
  pname = "lightning-loop";
  version = "0.35.2-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-R/h7ppPcwMyk5j2z74tiXVpvxgNKuttWK5D97aViY1U=";
  };

  vendorHash = "sha256-LoOSrpkoJpsD9llyM7ItflGJJqMqCHuM09E1nuKvHyw=";

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
