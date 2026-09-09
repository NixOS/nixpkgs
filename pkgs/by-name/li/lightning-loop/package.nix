{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "lightning-loop";
  version = "0.33.2-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NdwXEm5sj+Y5CPT9y658B6NTbM7heco5gLotyjBdg9c=";
  };

  vendorHash = "sha256-2/T/rt1Q86tyzNOiweuDLEAUiSoYTRf/RiERV6MBmZg=";

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
