{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "diffyml";
  version = "1.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "szhekpisov";
    repo = "diffyml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DIKHvFY/eW3CAF/ojW+D737vFCcZk0peRrSb8I/an9Q=";
  };

  vendorHash = "sha256-QE/EwVzMqUO24ZAl0WBibGx6x0kNo1AUTZtfnQvX50k=";

  # bench/compare and doc/gen-cli-ref are internal dev tools, not user-facing.
  excludedPackages = [
    "bench/compare"
    "doc/gen-cli-ref"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=v${finalAttrs.version}"
    "-X main.buildDate=1970-01-01"
  ];

  # test/ holds e2e (kind/kubectl) and repo-health suites that need network
  # and external tooling; unsuitable for the sandboxed build.
  preCheck = ''
    rm -rf test
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Structural YAML diff tool with Kubernetes awareness and CI-friendly output";
    homepage = "https://szhekpisov.github.io/diffyml/";
    downloadPage = "https://github.com/szhekpisov/diffyml";
    changelog = "https://github.com/szhekpisov/diffyml/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ szhekpisov ];
    mainProgram = "diffyml";
  };
})
