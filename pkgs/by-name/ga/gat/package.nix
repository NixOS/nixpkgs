{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gat";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8+IpVMbV+1aXNZoIWVZF/GDsLh2G1rHudkyifguGl0g=";
  };

  vendorHash = "sha256-UUFfM51toafSxK+x7Q7c9wPDiO22f7YfLc05u3uWLAE=";

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
