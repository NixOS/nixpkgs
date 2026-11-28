{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  nodejs,
  openssh,
  xdg-utils,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "machine0";
  version = "1.0.164";

  src = fetchurl {
    url = "https://registry.npmjs.org/@machine0/cli/-/cli-${finalAttrs.version}.tgz";
    hash = "sha256-7BLWBUZcV7l4KTwf0RvIn2+z7P1w5Q4KWAwsiA1jHdw=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  # The published package has no dependencies: it is a single prebundled ESM
  # file plus the entrypoint that loads it, so npm is not needed to install it.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/machine0
    cp -r bin dist package.json $out/lib/machine0/

    # ssh/ssh-keygen are called for `machine0 ssh` and key management,
    # xdg-open to open the browser when logging in.
    makeWrapper ${lib.getExe nodejs} $out/bin/machine0 \
      --add-flags $out/lib/machine0/bin/entry.cjs \
      --prefix PATH : ${
        lib.makeBinPath ([ openssh ] ++ lib.optional stdenvNoCC.hostPlatform.isLinux xdg-utils)
      }

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Cloud VMs from the CLI";
    homepage = "https://machine0.io";
    downloadPage = "https://www.npmjs.com/package/@machine0/cli";
    license = lib.licenses.unfree;
    mainProgram = "machine0";
    maintainers = with lib.maintainers; [ adithayyil ];
    platforms = lib.platforms.unix;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
})
