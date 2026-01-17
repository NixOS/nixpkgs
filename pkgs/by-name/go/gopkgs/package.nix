{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gopkgs";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "uudashr";
    repo = "gopkgs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ll5fhwzzCNL0UtMLNSGOY6Yyy0EqI8OZ1iqWad4KU8k=";
  };

  vendorHash = "sha256-WVikDxf79nEahKRn4Gw7Pv8AULQXW+RXGoA3ihBhmt8=";

  subPackages = [ "cmd/gopkgs" ];

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  # gopkgs doesn't support --version
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to get list available Go packages";
    mainProgram = "gopkgs";
    homepage = "https://github.com/uudashr/gopkgs";
    changelog = "https://github.com/uudashr/gopkgs/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.mit;
  };
})
