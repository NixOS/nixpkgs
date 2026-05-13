{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildGo125Module,
  stdenvNoCC,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nixosTests,
  nix-update-script,
}:
buildGo125Module (finalAttrs: {
  pname = "pocket-id";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "pocket-id";
    repo = "pocket-id";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2tGd/gl0Pm5b5GfkTsChvZoWov4dwljwqDcitX5NKCY=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2026-28513.patch";
      url = "https://github.com/pocket-id/pocket-id/commit/34890235ba8c2d856e3a121fdf59fe9d627e8596.patch?full_index=1";
      hash = "sha256-Th1/J9M7kxcXyuNa0CZIIX1CuIS31Dx12+O4bzSxS0E=";
    })
  ];

  patchFlags = [ "-p2" ];

  sourceRoot = "${finalAttrs.src.name}/backend";

  vendorHash = "sha256-ttbiuYRWbn8KRZtg499R4NF/E9+B+fOylxZcMwNg69M=";

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

  checkFlags = [
    # requires networking
    "-skip=TestOidcService_downloadAndSaveLogoFromURL"
  ];

  frontend = stdenvNoCC.mkDerivation {
    pname = "pocket-id-frontend";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_10
    ];
    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-Ybief+B7M1ATqHf9GlBlPFjII+ybCN4ATU94p0GKtI4=";
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
