{
  lib,
  fetchFromGitHub,
  buildGoModule,
  stdenvNoCC,
  nodejs,
  pnpm_10,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pocket-id";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "pocket-id";
    repo = "pocket-id";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u4H1wC5RL3p7GNL7WQkmK8DNgwKQvgxHd8TIug+Be+o=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  vendorHash = "sha256-guG/JnwUi2WeClSfAX9pRG3kLJMTvTDiJ7L54TGeSd0=";

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
      hash = "sha256-UgbclnoOqsWY5fYAGoDJON9MDtN5edw65JRleghdReE=";
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
