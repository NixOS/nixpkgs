{
  lib,
  buildNpmPackage,
  fetchFromGitHub,

  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeBinaryWrapper,
  nix-update-script,

  nodejs,
}:
let
  pnpm = pnpm_11;
in
buildNpmPackage (finalAttrs: {
  pname = "sub-store";
  version = "2.44.7";

  src = fetchFromGitHub {
    owner = "sub-store-org";
    repo = "Sub-Store";
    tag = finalAttrs.version;
    hash = "sha256-uzA9ENkfMoz8egMx683+jiS7QBXJWN+qq1sDebvgVKg=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  nativeBuildInputs = [
    makeBinaryWrapper
    pnpm
  ];

  postPatch = ''
    substituteInPlace pnpm-lock.yaml \
      --replace-fail 'resolution: {tarball: https://github.com/Delusions6515/shoutrrr-ts/releases/download/v0.2.0/shoutrrr-ts-0.2.0.tgz}' \
        'resolution: {integrity: sha512-K/Cj26Dbg1epa163VfprhsP50aFmGTi71ocI9ch0uSZFdUr+P11bgLGdk88bX2w/w/nlwm8jZJ5dCugfYhqDUw==, tarball: https://github.com/Delusions6515/shoutrrr-ts/releases/download/v0.2.0/shoutrrr-ts-0.2.0.tgz}'
  '';

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      postPatch
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-KPH5h9ofuyu0PZlSSE0PjI/0yYFTKs72Q10h0y+KF74=";
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
