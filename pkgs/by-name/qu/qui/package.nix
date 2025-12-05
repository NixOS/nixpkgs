{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  nodejs,
  pnpm_9,
  typescript,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "qui";
  version = "1.8.1";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "qui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1cIKbP+c2Tqs4uoBWvfAQGDBLqmXh17rFZDuGRYWrYA=";
  };

  qui-web = stdenvNoCC.mkDerivation (finalAttrs': {
    pname = "${finalAttrs.pname}-web";
    inherit (finalAttrs) src version;

    nativeBuildInputs = [
      nodejs
      pnpm_9.configHook
      typescript
    ];

    sourceRoot = "${finalAttrs.src.name}/web";

    pnpmDeps = pnpm_9.fetchDeps {
      inherit (finalAttrs')
        pname
        version
        src
        sourceRoot
        ;
      fetcherVersion = 2;
      hash = "sha256-4adyjeQI2+deJPgwA81FmYZCY0QEEUjVP2lF/BeXr4Q=";
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  });

  vendorHash = "sha256-GaLilaRnVEIItb0yIdnf7F6KCDRPc7Gy3mgtuMwf7j4=";

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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "qui-web"
    ];
  };

  meta = {
    description = "Modern alternative webUI for qBittorrent, with multi-instance support";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/autobrr/qui";
    changelog = "https://github.com/autobrr/qui/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ pta2002 ];
    mainProgram = "qui";
    platforms = lib.platforms.unix;
  };
})
