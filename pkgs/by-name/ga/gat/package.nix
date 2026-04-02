{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gat";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xydy+iKBfO1np/jtzWHFNUmXqb545ldWtwqMymaah2c=";
  };

  vendorHash = "sha256-0kNtZOTpWpeFVyRHFIf6ybM7gAWb5/JWVljm0FO5fK8=";

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
