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
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "pocket-id";
    repo = "pocket-id";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4BtVTfjXu/V9l4L2ucabpQXjrTBEB4cTrO4tb/oE3YU=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  vendorHash = "sha256-SrpUgyruwbIJZ1HB6sqidbGAwzBOqKcJzR+cH9E0siw=";

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

  # many tests time out on darwin when waiting for 127.0.0.1 with only `__darwinAllowLocalNetworking = true`
  # caused by `quic.DialAddr` of `quic-go`, works after loosening the sandbox
  __darwinAllowLocalNetworking = finalAttrs.finalPackage.doCheck;
  sandboxProfile = lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    (allow network* (remote ip "*:*"))
  '';

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
      hash = "sha256-KswQQVz2Xw/dG21134SObM3mQAKP2IHc+UM/BX/dvrI=";
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
