{
  lib,
  buildGoModule,
  fetchFromGitLab,
  nix-update-script,
  sarif-converter,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "sarif-converter";
  version = "0.9.4";

  src = fetchFromGitLab {
    owner = "ignis-build";
    repo = "sarif-converter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q8L4C4mTJEfxASqrUAZlMoLx71/+nmP6mwW/vNFStTs=";
  };

  vendorHash = "sha256-vK+HhHlFWoWIrDEZzfRoqtJ3vKp0f4b8l8+LBlZuBJU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/main $out/bin/sarif-converter
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = sarif-converter;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Convert from [SARIF](https://sarifweb.azurewebsites.net/) to GitLab Code Quality and SAST report";
    homepage = "https://gitlab.com/ignis-build/sarif-converter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "sarif-converter";
  };
})
