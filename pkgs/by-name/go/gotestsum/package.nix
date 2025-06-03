{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "gotestsum";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l4K+8J24egaKS64inQrBWnPLLGBu1W03OUi4WWQoAgs=";
  };

  vendorHash = "sha256-SJacdFAdMiKDGLnEEBKnblvHglIBIKf2N20EOFCPs88=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X gotest.tools/gotestsum/cmd.version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/gotestyourself/gotestsum";
    changelog = "https://github.com/gotestyourself/gotestsum/releases/tag/v${finalAttrs.version}";
    description = "Human friendly `go test` runner";
    mainProgram = "gotestsum";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
