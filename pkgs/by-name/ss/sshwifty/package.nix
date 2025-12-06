{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  versionCheckHook,
  nixosTests,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "sshwifty";
  version = "0.4.1-beta-release";

  src = fetchFromGitHub {
    owner = "nirui";
    repo = "sshwifty";
    tag = finalAttrs.version;
    hash = "sha256-Kg5aE4lkzSedo+VJgdsfO5XTKupsPU2DhZNdNhEQ/Q4=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.filter (drv: drv != npmHooks.npmConfigHook) oldAttrs.nativeBuildInputs;
    preBuild = null;
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-vX3CtjwjzcxxIPYG6QXsPybyBRow1YdS9pHr961P1HA=";
  };

  vendorHash = "sha256-/SLUC0xM195QfKgX9te8UP1bbzRbKF+Npyugi19JijY=";

  preBuild = ''
    # Generate static pages
    npm run generate
  '';

  ldflags = [
    "-s"
    "-X github.com/nirui/sshwifty/application.version=${finalAttrs.version}"
  ];

  postInstall = ''
    find $out/bin ! -name sshwifty -type f -exec rm -rf {} \;
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) sshwifty; };
    updateScript = nix-update-script {
      extraArgs = [
        "--version=unstable"
        "--version-regex=^([0-9.]+(?!.+-prebuild).+$)"
      ];
    };
  };

  meta = {
    description = "WebSSH & WebTelnet client";
    homepage = "https://github.com/nirui/sshwifty";
    changelog = "https://github.com/nirui/sshwifty/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "sshwifty";
  };
})
