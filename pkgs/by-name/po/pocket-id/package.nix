{
  lib,
  fetchFromGitHub,
  buildGo127Module,
  stdenvNoCC,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:
buildGo127Module (finalAttrs: {
  pname = "pocket-id";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "pocket-id";
    repo = "pocket-id";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n9yqZs8RlgJk+NByRJ7a+HRY4YkQNNH7xY02BSy/RhE=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  vendorHash = "sha256-BGIF9ZhPAJrUvX1cahe3EyWM3QLIfkkZaChaBign7io=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-X github.com/pocket-id/pocket-id/backend/internal/common.Version=${finalAttrs.version}"
    "-buildid=${finalAttrs.version}"
  ];

  preBuild = ''
    cp -r ${finalAttrs.frontend}/lib/pocket-id-frontend/dist frontend/dist
  '';

  checkFlags = [
    "-tags=unit"
  ];

  # required for TestIsURLPrivate
  __darwinAllowLocalNetworking = finalAttrs.finalPackage.doCheck;

  preFixup = ''
    mv $out/bin/cmd $out/bin/pocket-id
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  frontend = stdenvNoCC.mkDerivation {
    pname = "pocket-id-frontend";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpmBuildHook
      pnpm_10
    ];
    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_10;
      fetcherVersion = 4;
      hash = "sha256-iXWR3idBiafZXCrt1M7UCJQJsA+IL2AU6pRJI7MdY1E=";
    };

    env.BUILD_OUTPUT_PATH = "dist";

    pnpmWorkspaces = [ "pocket-id-frontend" ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/pocket-id-frontend
      cp -r frontend/dist $out/lib/pocket-id-frontend/dist

      runHook postInstall
    '';
  };

  passthru = {
    tests = {
      inherit (nixosTests) pocket-id;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = {
    description = "OIDC provider with passkeys support";
    homepage = "https://pocket-id.org";
    changelog = "https://github.com/pocket-id/pocket-id/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    mainProgram = "pocket-id";
    maintainers = with lib.maintainers; [
      gepbird
      marcusramberg
      tmarkus
      ymstnt
      esch
    ];
    platforms = lib.platforms.unix;
  };
})
