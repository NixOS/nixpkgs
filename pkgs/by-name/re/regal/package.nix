{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "regal";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "regal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m2KA+TZqFN0h+eUj5Pj36aGjiJegxbeKlAvudt2giiE=";
  };

  vendorHash = "sha256-SvJVf6Q7d8Or7iBL2yU1uZ5nY4HNV1fH8x0R0sN/g0o=";

  # Only build the main binary, exclude build/lsp/main.go
  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-policy-agent/regal/pkg/version.Version=${finalAttrs.version}"
    "-X github.com/open-policy-agent/regal/pkg/version.Commit=${finalAttrs.version}"
  ];

  meta = {
    description = "Linter and language server for Rego";
    mainProgram = "regal";
    homepage = "https://github.com/open-policy-agent/regal";
    changelog = "https://github.com/open-policy-agent/regal/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rinx ];
  };
})
