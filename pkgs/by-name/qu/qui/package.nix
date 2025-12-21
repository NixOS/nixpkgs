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
  version = "1.10.0";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "qui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aGCEv/HX2XYhtJqWtLHKjsBIy8WYOwezxGQxfF6lu0M=";
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
      hash = "sha256-6brOEC1UAxjIZB4pujhA624jKTTxfZQiiz/PzqooPeA=";
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  });

  vendorHash = "sha256-EJ26MqXxdV9m5reqWAYTXwuHLMbf2l1J3667e1FEv7A=";

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
