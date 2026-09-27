{
  fetchurl,
  lib,
  nix-update-script,
  stdenvNoCC,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "keepingyouawake";
  version = "1.6.8";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/newmarcel/KeepingYouAwake/releases/download/${finalAttrs.version}/KeepingYouAwake-${finalAttrs.version}.zip";
    hash = "sha256-gAGhSbRJDACP2sGYmLzpkC1RbEqmQSp+sPmjdEOxXGs=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r KeepingYouAwake.app "$out/Applications/"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    changelog = "https://github.com/newmarcel/KeepingYouAwake/releases/tag/${finalAttrs.version}";
    description = "Menu bar utility that prevents macOS from going to sleep";
    homepage = "https://keepingyouawake.app/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tpansino ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
