{
  fetchFromGitHub,
  buildGo127Module,
  stdenvNoCC,
  nix-update-script,
  nodejs,
  lib,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
}:
let
  pnpm = pnpm_11;
in
buildGo127Module (finalAttrs: {
  pname = "memos";
  version = "0.31.0";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${finalAttrs.version}";
    hash = "sha256-O6r+M+T6zDr9getunGgNSXJlmt3ZsSwTCYoSpVgDcM4=";
  };

  memos-web = stdenvNoCC.mkDerivation (finalWebAttrs: {
    pname = "memos-web";
    inherit (finalAttrs) version src;
    pnpmDeps = fetchPnpmDeps {
      inherit (finalWebAttrs) pname version src;
      inherit pnpm;
      sourceRoot = "${finalWebAttrs.src.name}/web";
      fetcherVersion = 4;
      hash = "sha256-GkLRGTefn85bZ652/sW4xrBHZ6QsVn/cTBb7UoU8UQQ=";
    };
    pnpmRoot = "web";
    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];
    buildPhase = ''
      runHook preBuild
      pnpm -C web build
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      cp -r web/dist $out
      runHook postInstall
    '';
  });

  vendorHash = "sha256-AJkTk34kYa2I24F+naj9GX8b2YYhqTuK6i9MvDUoBU0=";

  ldflags = [
    "-X github.com/usememos/memos/internal/version.Version=${finalAttrs.version}"
  ];

  preBuild = ''
    rm -rf server/frontend/dist
    cp -r ${finalAttrs.memos-web} server/frontend/dist
  '';

  checkFlags =
    let
      skippedTests = [
        "TestEntrypointDoesNotLoopWhenTargetUIDIsRoot" # requires root
        "TestUserWebhookSigningSecretLifecycle" # requires internet access for example.com
        "TestDetectAttachmentMimeType" # REMOVE NEXT RELEASE: bug in test, fixed by https://github.com/usememos/memos/pull/6353
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "memos-web"
    ];
  };

  meta = {
    homepage = "https://usememos.com";
    description = "Lightweight, self-hosted memo hub";
    changelog = "https://github.com/usememos/memos/releases/tag/${finalAttrs.src.rev}";
    maintainers = with lib.maintainers; [
      indexyz
      kuflierl
    ];
    license = lib.licenses.mit;
    mainProgram = "memos";
  };
})
