{
  buildGoModule,
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  nix-update-script,
  nixosTests,
  nodejs-slim_24,
  pnpmBuildHook,
  pnpmConfigHook,
  pnpm_11,
  stdenvNoCC,
  versionCheckHook,
}:
let
  nodejs-slim = nodejs-slim_24;
  pnpm = pnpm_11.override { inherit nodejs-slim; };
in
buildGoModule (finalAttrs: {
  pname = "autobrr";
  version = "1.90.0";

  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "autobrr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Her0vuexuxzeW/cVLLQUMSTQVbMnOP0tkJRfqg0ZkL0=";
  };

  vendorHash = "sha256-97U3ZOJK/3klKxV8L68Ul6DvFQN1Ow/igtUE94DAfD0=";

  excludedPackages = [
    "test/mockdiscord"
    "test/mockindexer"
  ];

  preBuild = ''
    cp -rT ${finalAttrs.passthru.web} web/dist
  '';

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  checkFlags = lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    # stats /etc/passwd, which the darwin sandbox denies
    "-skip=^TestIsOwnedByCurrentUser_OtherUser$"
  ];

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru = {
    tests = { inherit (nixosTests) autobrr; };
    updateScript = nix-update-script { extraArgs = [ "--subpackage=web" ]; };
    web = stdenvNoCC.mkDerivation (finalAttrs': {
      pname = "${finalAttrs.pname}-web";
      inherit (finalAttrs) version src;

      sourceRoot = "${finalAttrs'.src.name}/web";

      nativeBuildInputs = [
        nodejs-slim
        pnpm
        pnpmBuildHook
        pnpmConfigHook
      ];

      pnpmDeps = fetchPnpmDeps {
        inherit (finalAttrs')
          pname
          version
          src
          sourceRoot
          ;
        inherit pnpm;
        fetcherVersion = 5;
        hash = "sha256-JYD+zmxx/kWijYjwHpjLeMgH/Lk61R/3xpgxVtjN+EI=";
      };

      installPhase = ''
        runHook preInstall
        cp -r dist "$out"
        runHook postInstall
      '';
    });
  };

  meta = {
    description = "Download automation for torrents and usenet";
    homepage = "https://autobrr.com/";
    changelog = "https://github.com/autobrr/autobrr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [
      av-gal
      connor-grady
    ];
    mainProgram = "autobrr";
    platforms = with lib.platforms; darwin ++ freebsd ++ linux;
  };
})
