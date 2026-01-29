{
  lib,
  buildGoModule,
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
buildGoModule (finalAttrs: {
  pname = "qui";
  version = "1.12.0";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "qui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j0d8aJ9qcK3+/g+qNBsH84U5zQho6bl5TdzHQRQsabs=";
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
      fetcherVersion = 2;
      hash = "sha256-3TAB5StrKBmgit02J7GiMfk6EDl8oiLvcOAnCJ9ian4=";
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  });

  vendorHash = "sha256-hdgTC/oA2ZUc7mqA3v1vunXcu+aeKGw2fEUBBeerCeg=";

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
