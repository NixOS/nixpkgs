{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-actions-lock";
  version = "0.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-actions-lock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9jU5NmBFZayhOX8ifc+aMDhaIQ4XVPlLI/dPUoQuzNw=";
  };

  # debug.ReadBuildInfo does not provide version information in buildGoModule.
  # Keep the upstream "v" prefix format because the "--json" includes it.
  postPatch = ''
    substituteInPlace cmd/gh-actions-lock/run.go \
      --replace-fail 'return info.Main.Version' 'return "v${finalAttrs.version}"'
  '';

  vendorHash = "sha256-MS0GDAo/COikI5LwfgNPR83MhY6fAFg+Lpmzkv86X3M=";

  ldflags = [
    "-s"
  ];

  env.CGO_ENABLED = "0";

  # Workaround for: panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  # ref: https://github.com/NixOS/nix/pull/1646
  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

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
      mdaniels5757
    ];
    mainProgram = "gh-actions-lock";
    platforms = with lib.platforms; unix ++ windows;
  };
})
