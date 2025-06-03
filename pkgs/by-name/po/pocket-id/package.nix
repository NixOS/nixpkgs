{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pocket-id";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "pocket-id";
    repo = "pocket-id";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J/s8wpKAU7w8Djtd7rtamCzg/7176W0ybSoAB/vHOjs=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  vendorHash = "sha256-jLwuBYiFZhUDIvG5uk78vXmo+wuqkFmyC5lAUZ3vUxU=";

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

  frontend = buildNpmPackage {
    pname = "pocket-id-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/frontend";

    npmDepsHash = "sha256-ykoyJtnqFK1fK60SbzrL7nhRcKYa3qYdHf9kFOC3EwE=";
    npmFlags = [ "--legacy-peer-deps" ];

    env.BUILD_OUTPUT_PATH = "dist";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/pocket-id-frontend
      cp -r dist $out/lib/pocket-id-frontend/dist

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
