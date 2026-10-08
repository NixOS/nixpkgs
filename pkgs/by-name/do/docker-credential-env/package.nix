{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "docker-credential-env";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "isometry";
    repo = "docker-credential-env";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KsOLY1XDJVrsm2rnDCffPqtlD2yw+arWsJaItwoOyUQ=";
  };

  vendorHash = "sha256-Qr6T7NJaJcFD0EYuPS7mWJi0tjyut1aQ+Wbarc0tpGY=";

  ldflags =
    let
      c = "github.com/docker/docker-credential-helpers/credentials";
    in
    [
      "-s"
      "-X=${c}.Name=docker-credential-env"
      "-X=${c}.Package=github.com/isometry/docker-credential-env"
      "-X=${c}.Version=${finalAttrs.version}"
      "-X=${c}.Revision=${finalAttrs.src.tag}"
    ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/isometry/docker-credential-env/releases/tag/${finalAttrs.src.tag}";
    description = "Environment-driven docker credential helper";
    homepage = "https://github.com/isometry/docker-credential-env";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zowoq ];
    mainProgram = "docker-credential-env";
  };
})
