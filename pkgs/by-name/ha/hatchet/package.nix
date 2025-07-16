{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "hatchet";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "simagix";
    repo = "hatchet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m/TuO5Z4Pc2Hruxb2uRwKcccUQjExnGOt3A0fqXVt5s=";
  };

  vendorHash = "sha256-FbwwAeK9L6yIVZEBN1Ay5PB2D89vQNjbtMG5pI5jAAw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
    "-X main.repo=${finalAttrs.src.owner}/${finalAttrs.src.repo}"
  ];

  postInstall = "mv $out/bin/main $out/bin/${finalAttrs.meta.mainProgram}";

  # the tests are using fixture files not available from the git repo.
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/simagix/hatchet";
    changelog = "https://github.com/simagix/hatchet/releases/tag/${finalAttrs.src.tag}";
    description = "MongoDB JSON Log Analyzer";
    maintainers = with lib.maintainers; [ aduh95 ];
    license = lib.licenses.asl20;
    mainProgram = "hatchet";
  };
})
