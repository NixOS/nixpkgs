{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-actions-lock";
  version = "0.1.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-actions-lock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OqxkuQPM0JwhTLWUgeNdaMRDj2uuAX/dGEDyanJV8iY=";
  };

  # debug.ReadBuildInfo does not provide version information in buildGoModule.
  # Keep the upstream "v" prefix format because the "--json" includes it.
  postPatch = ''
    substituteInPlace cmd/gh-actions-lock/run.go \
      --replace-fail 'return info.Main.Version' 'return "v${finalAttrs.version}"'
  '';

  vendorHash = "sha256-AYrg81SYC2JBpRZgG8O9R5ymCAsX8hsipwoSS1mP/Uc=";

  ldflags = [
    "-s"
  ];

  env.CGO_ENABLED = "0";

  # Workaround for: panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  # ref: https://github.com/NixOS/nix/pull/1646
  __darwinAllowLocalNetworking = true;

  # Cannot use versionCheckHook because there is no flag to show the CLI version.
  # "--no-fix --json" shows it, but it requires a real GitHub account.
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/${finalAttrs.meta.mainProgram}" --help
    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases"
        "--version-regex=^v([0-9.]+)$"
      ];
    };
  };

  meta = {
    description = "GitHub CLI extension to lock workflow dependencies";
    homepage = "https://github.com/github/gh-actions-lock";
    changelog = "https://github.com/github/gh-actions-lock/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "gh-actions-lock";
    platforms = with lib.platforms; unix ++ windows;
  };
})
