{
  lib,
  buildNpmPackage,
  fetchFromGitHub,

  pnpm_10,
  pnpm ? pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeBinaryWrapper,
  nix-update-script,

  nodejs,
}:

buildNpmPackage (finalAttrs: {
  pname = "sub-store";
  version = "2.21.98";

  src = fetchFromGitHub {
    owner = "sub-store-org";
    repo = "Sub-Store";
    tag = finalAttrs.version;
    hash = "sha256-r2zlOZQ6pPxm/zjtaJkMMaG3vM/05xvS+hTDg4bydo8=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  nativeBuildInputs = [
    makeBinaryWrapper
    pnpm
  ];

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-4RFzky/KaRSNvBizH717KtiwavO+KB69AwPKAAnTmh4=";
  };

  npmConfigHook = pnpmConfigHook;
  npmBuildScript = "bundle:esbuild";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r dist $out/share/sub-store
    makeWrapper ${lib.getExe nodejs} $out/bin/sub-store \
      --add-flags "$out/share/sub-store/sub-store.bundle.js"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Advanced Subscription Manager for QX, Loon, Surge, Stash, Egern and Shadowrocket";
    homepage = "https://github.com/sub-store-org/Sub-Store";
    changelog = "https://github.com/sub-store-org/Sub-Store/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "sub-store";
    platforms = nodejs.meta.platforms;
  };
})
