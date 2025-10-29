{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "athens";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "gomods";
    repo = "athens";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qF5sSpWtw1qTxfaZkQse882JjE5idP2Wk0RVsPmzIlY=";
  };

  vendorHash = "sha256-bn3He7ImXxrl+Or2pqzVpM8VxbfqDDupwtZbdSMd4HI=";

  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-X github.com/gomods/athens/pkg/build.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/proxy" ];

  postInstall = ''
    mv $out/bin/proxy $out/bin/athens
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go module datastore and proxy";
    homepage = "https://github.com/gomods/athens";
    changelog = "https://github.com/gomods/athens/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "athens";
    maintainers = with lib.maintainers; [
      katexochen
      malt3
    ];
    platforms = lib.platforms.unix;
  };
})
