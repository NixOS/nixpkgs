{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  versionCheckHook,
  nixosTests,
  nix-update-script,
}:
buildGoLatestModule (finalAttrs: {
  pname = "sshwifty";
  version = "0.4.10-beta-release";

  src = fetchFromGitHub {
    owner = "nirui";
    repo = "sshwifty";
    tag = finalAttrs.version;
    hash = "sha256-6Yxwz4AXyUKz9FredI3c1HpjptaV2X0iXY+z8Lev1xg=";
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
    hash = "sha256-GYcqCYQ/l21q1vvIkl9np+1ko5woD004OFXiW4jSkZc=";
  };

  vendorHash = "sha256-O3oEbTGJWWWTQSadctcBy0lpNzovw7SCT9/7moJOs0g=";

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
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "sshwifty";
  };
})
