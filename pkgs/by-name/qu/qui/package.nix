{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  nodejs,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  typescript,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "qui";
<<<<<<< HEAD
  version = "1.11.0";
=======
  version = "1.7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "qui";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ioyFTTJu2B0m+U+GgY/VOIesAZLQI3mRZ5ZBh77emFY=";
=======
    hash = "sha256-CbPdngskDCAAhmsj5DPdnviZSWM0bO13Pbe7wRwaNaw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  qui-web = stdenvNoCC.mkDerivation (finalAttrs': {
    pname = "${finalAttrs.pname}-web";
    inherit (finalAttrs) src version;

    nativeBuildInputs = [
      nodejs
<<<<<<< HEAD
      pnpmConfigHook
      pnpm_9
=======
      pnpm_9.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      typescript
    ];

    sourceRoot = "${finalAttrs.src.name}/web";

<<<<<<< HEAD
    pnpmDeps = fetchPnpmDeps {
=======
    pnpmDeps = pnpm_9.fetchDeps {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      inherit (finalAttrs')
        pname
        version
        src
        sourceRoot
        ;
<<<<<<< HEAD
      pnpm = pnpm_9;
      fetcherVersion = 2;
      hash = "sha256-6brOEC1UAxjIZB4pujhA624jKTTxfZQiiz/PzqooPeA=";
=======
      fetcherVersion = 2;
      hash = "sha256-WKoWts+/TGcGy/rFEJN3Qn/vq+gj+Mq+VcTYowEyvus=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  });

<<<<<<< HEAD
  vendorHash = "sha256-clVC3xPV/vJpWogDs1a977osQgPyhvZ4CRnHnKEZMs0=";
=======
  vendorHash = "sha256-rmUEFX8UzxEN7XaJ8Zj+kj3z1pwLkq3FTYzbPWnifW0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
