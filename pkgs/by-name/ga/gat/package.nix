{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gat";
  version = "0.25.8";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    tag = "v${version}";
    hash = "sha256-OT0TiYvbeybWPk2Sku38ip+qmUUuFRMu1wC9936EByY=";
  };

  vendorHash = "sha256-LOim/rW8Uz5stpIQj2Ubx4F3bTv6nNAn2ZbWqW6B4rU=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/koki-develop/gat/cmd.version=v${version}"
  ];

  meta = {
    description = "Cat alternative written in Go";
    license = lib.licenses.mit;
    homepage = "https://github.com/koki-develop/gat";
    maintainers = with lib.maintainers; [ themaxmur ];
    mainProgram = "gat";
  };
}
