{
  lib,
  fetchFromGitHub,
  buildGo125Module,
  stdenvNoCC,
  nodejs,
  pnpm_10,
  nixosTests,
  nix-update-script,
}:

buildGo125Module (finalAttrs: {
  pname = "pocket-id";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "pocket-id";
    repo = "pocket-id";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3sUkEbC96/XUR1tvCmxu56hPh7Ag/sD6/pGrq9JhHC8=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  vendorHash = "sha256-eNUhk76YLHtXCFaxiavM6d8CMeE+YQ+vOecDUCiTh5k=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-X github.com/pocket-id/pocket-id/backend/internal/common.Version=${finalAttrs.version}"
    "-buildid=${finalAttrs.version}"
  ];

  preBuild = ''
    cp -r ${finalAttrs.frontend}/lib/pocket-id-frontend/dist frontend/dist
  '';

  preFixup = ''
    mv $out/bin/cmd $out/bin/pocket-id
  '';

  frontend = stdenvNoCC.mkDerivation {
    pname = "pocket-id-frontend";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      nodejs
      pnpm_10.configHook
    ];
    pnpmDeps = pnpm_10.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 1;
      hash = "sha256-q2oXyFVdaDfJ4NFDt26/VJVXzQLCuKXHtCx1mah6Js8=";
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
