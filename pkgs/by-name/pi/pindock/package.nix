{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pindock";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deadnews";
    repo = "pindock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GPpedgk/DtWzf4u//i79BY9lKj6eb8+/WzJo7rtaTpA=";
  };

  vendorHash = "sha256-enthX/V7yH7IMMbKBDVt/955TZ7QaSyZhlGJwy13mSU=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pin and update Docker image digests in Dockerfiles and compose files";
    homepage = "https://github.com/deadnews/pindock";
    changelog = "https://github.com/deadnews/pindock/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "pindock";
  };
})
