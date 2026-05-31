{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "gat";
  version = "0.30.1";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fIsnnmfl2RZVXIFypfINozVaGaV9bBNgjoqCdDn6PEs=";
  };

  vendorHash = "sha256-HHhvJNuoUHjHdQ864YpUWxRHCXeL/cd4EHSFq3N2mo4=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/koki-develop/gat/cmd.version=v${finalAttrs.version}"
  ];

  meta = {
    description = "Cat alternative written in Go";
    license = lib.licenses.mit;
    homepage = "https://github.com/koki-develop/gat";
    maintainers = with lib.maintainers; [ themaxmur ];
    mainProgram = "gat";
  };
})
