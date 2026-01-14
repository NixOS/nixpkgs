{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "hatchet";
  version = "0.8.10";

  src = fetchFromGitHub {
    owner = "simagix";
    repo = "hatchet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TdZ8yKDpphPQnjMHKVICV0vj8FSWlHsAAa6X1p1gqH0=";
  };

  vendorHash = "sha256-NUGNvyXw07erw6MqJm/VbwCvW59WCeKdMJ1Dq0z5viI=";

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
