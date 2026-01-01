{
  lib,
  fetchFromGitHub,
  buildGo125Module,
  stdenvNoCC,
  nodejs,
  pnpm_10,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
  nixosTests,
  nix-update-script,
}:
buildGo125Module (finalAttrs: {
  pname = "pocket-id";
  version = "1.16.0";
=======
  nixosTests,
  nix-update-script,
}:

buildGo125Module (finalAttrs: {
  pname = "pocket-id";
  version = "1.15.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pocket-id";
    repo = "pocket-id";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-2tGd/gl0Pm5b5GfkTsChvZoWov4dwljwqDcitX5NKCY=";
=======
    hash = "sha256-mnmBwQ79sScTPM4Gh9g0x/QTmqm1TgxaOkww+bvs1b4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

<<<<<<< HEAD
  vendorHash = "sha256-ttbiuYRWbn8KRZtg499R4NF/E9+B+fOylxZcMwNg69M=";
=======
  vendorHash = "sha256-CmhPURPNwcpmD9shLrQPVKFGBirEMjq0Z4lmgMCpxS8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  env.CGO_ENABLED = 0;
  ldflags = [
    "-X github.com/pocket-id/pocket-id/backend/internal/common.Version=${finalAttrs.version}"
    "-buildid=${finalAttrs.version}"
  ];

  preBuild = ''
    cp -r ${finalAttrs.frontend}/lib/pocket-id-frontend/dist frontend/dist
  '';

<<<<<<< HEAD
  checkFlags = [
    # requires networking
    "-skip=TestOidcService_downloadAndSaveLogoFromURL"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  preFixup = ''
    mv $out/bin/cmd $out/bin/pocket-id
  '';

  frontend = stdenvNoCC.mkDerivation {
    pname = "pocket-id-frontend";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      nodejs
<<<<<<< HEAD
      pnpmConfigHook
      pnpm_10
    ];
    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_10;
      fetcherVersion = 1;
      hash = "sha256-drXGcUHP7J7keGra7/x1tr9Pfh/wjzmtUE1yAybYXLQ=";
=======
      pnpm_10.configHook
    ];
    pnpmDeps = pnpm_10.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 1;
      hash = "sha256-/e1zBHdy3exqbMvlv0Jth7vpJd7DDnWXGfMV+Cdr56I=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
      ymstnt
    ];
    platforms = lib.platforms.unix;
  };
})
