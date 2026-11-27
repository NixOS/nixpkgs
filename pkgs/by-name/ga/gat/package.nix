{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gat";
  version = "0.31.2";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3wlG1eiRMAU2oU+9zO+w9wvsmivYk/mvt9pQkO1nzjQ=";
  };

  vendorHash = "sha256-IGGRo3tLUKVnHtxa4nwwDJnP8lyCaRuElzmIZ58TJCo=";

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
