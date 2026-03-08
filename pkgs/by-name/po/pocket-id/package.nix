{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  stdenvNoCC,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:
buildGo126Module (finalAttrs: {
  pname = "pocket-id";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "pocket-id";
    repo = "pocket-id";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2EK6+QMy2DSZRAHaKcUAfINUlHlRYjEoCtofUxq0w9c=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  vendorHash = "sha256-E/LiovOJ+tKQOeX+rH1TfVFa803zmq3D895uzXUI4oI=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-X github.com/pocket-id/pocket-id/backend/internal/common.Version=${finalAttrs.version}"
    "-buildid=${finalAttrs.version}"
  ];

  preBuild = ''
    cp -r ${finalAttrs.frontend}/lib/pocket-id-frontend/dist frontend/dist
  '';

  checkFlags = [
    # requires networking
    "-skip=TestOidcService_downloadAndSaveLogoFromURL"
  ];

  # required for TestIsURLPrivate
  __darwinAllowLocalNetworking = finalAttrs.doCheck;

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
      pnpm_10
    ];
    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-jaluy/rzArCZ8iI2G0jPHraBIqG/6GsPVFv44lAdXoI=";
    };

    env.BUILD_OUTPUT_PATH = "dist";

    buildPhase = ''
      runHook preBuild

      pnpm --filter pocket-id-frontend build

      runHook postBuild
    '';

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
    ];
    platforms = lib.platforms.unix;
  };
})
