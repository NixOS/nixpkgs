{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  stdenvNoCC,
  nixosTests,
  nix-update-script,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  typescript,
  versionCheckHook,
}:
buildGo126Module (finalAttrs: {
  pname = "qui";
  version = "1.18.0";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "qui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rdg8fcoUY7WrNXj+LZyMXx6hFo8+OGrCLjhE3JD1y4o=";
  };

  qui-web = stdenvNoCC.mkDerivation (finalAttrs': {
    pname = "${finalAttrs.pname}-web";
    inherit (finalAttrs) src version;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_9
      typescript
    ];

    sourceRoot = "${finalAttrs.src.name}/web";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs')
        pname
        version
        src
        sourceRoot
        ;
      pnpm = pnpm_9;
      fetcherVersion = 3;
      hash = "sha256-hCiIbVroyMhl2xT0WAGbmLSXfUH6RJHlC1g3isMlUJs=";
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  });

  vendorHash = "sha256-7MzKE3pBvoW/ajB6gHtBBS1M/NuQsRw3ZSNtCJzrEyI=";

  preBuild = ''
    cp -r ${finalAttrs.qui-web}/* web/dist
  '';

  ldflags = [
    "-X github.com/autobrr/qui/internal/buildinfo.Version=${finalAttrs.version}"
    "-X main.PolarOrgID="
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  # Required for tests on Darwin
  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "qui-web"
      ];
    };
    tests.testService = nixosTests.qui;
  };

  meta = {
    description = "Modern alternative webUI for qBittorrent, with multi-instance support";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/autobrr/qui";
    changelog = "https://github.com/autobrr/qui/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      pta2002
      tmarkus
    ];
    mainProgram = "qui";
    platforms = lib.platforms.unix;
  };
})
