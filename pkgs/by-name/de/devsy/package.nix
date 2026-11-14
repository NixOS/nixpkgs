{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "devsy";
  version = "1.16.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "devsy-org";
    repo = "devsy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tp79X1TXDaPL2+pAK90WllRWXmHGl5ySzT/X7KSyGGg=";
  };

  vendorHash = "sha256-3Xw9Uc9zJUqDUf8Xpyh2FHqx2XLGp9edvrvh4VDiATo=";

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  tags = lib.optionals stdenv.hostPlatform.isLinux [
    "netgo"
    "osusergo"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/devsy-org/devsy/pkg/version.version=v${finalAttrs.version}"
    "-X github.com/devsy-org/devsy/pkg/telemetry/analytics.posthogAPIKey="
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Deploy devcontainers onto cloud providers, Kubernetes, and Docker";
    homepage = "https://devsy.sh";
    changelog = "https://github.com/devsy-org/devsy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ tyceherrman ];
    mainProgram = "devsy";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
