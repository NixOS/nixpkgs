{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {

  pname = "ast-metrics";
  version = "0.43.1";
  vendorHash = "sha256-UPJAFe3Y+3nLKSMa0ZKm/o0PwhxsBmfI9OVPhWk8Cpw=";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ast-metrics";
    repo = "ast-metrics";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-kQg1JaNfI6V3kl6oStrxGBMFdGAGoPoR0I9Ba4olrSk=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # needed to solve a problem with tree-sitter
  proxyVendor = true;
  subPackages = [ "./cmd/ast-metrics" ];

  doInstallCheck = true;
  versionCheckProgramArg = "v";
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "AST Metrics measures complexity, coupling, architecture, bus factor and test quality for PHP, Go, Python, Rust, Java, C# and TypeScript";
    homepage = "https://ast-metrics.dev/";
    changelog = "https://github.com/ast-metrics/ast-metrics/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ast-metrics";
    maintainers = with lib.maintainers; [ charly ];
  };
})
