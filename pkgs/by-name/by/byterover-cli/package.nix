{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  nodejs_24,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "byterover-cli";
  version = "3.16.1";
  commit = "1f4609c";

  passthru = {
    srcHashes = {
      x86_64-linux = "sha256-V3EVPa6XGqFFJ5FtI486lwtbAKULVHwZw1Tz+oRbRu4=";
      aarch64-linux = "sha256-uStXYNsSgGG2QRy8QwIIU83XWVaNiL5KanZVMeZAgW4=";
    };
    srcHash =
      finalAttrs.passthru.srcHashes.${stdenv.hostPlatform.system}
        or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
  };

  # Source build not feasible – @campfirein/byterover-packages (git submodule)
  # is not publicly accessible, blocking npm ci at dependency resolution.
  src = fetchurl {
    url = "https://storage.googleapis.com/brv-releases/versions/${finalAttrs.version}/${finalAttrs.commit}/brv-v${finalAttrs.version}-${finalAttrs.commit}-${
      with stdenv.hostPlatform.node; "${platform}-${arch}"
    }.tar.gz";
    hash = finalAttrs.passthru.srcHash;
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    # oclif bundles Node.js 24.13.1 — pin to same major version
    nodejs_24
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{lib,bin}
    cp -r . $out/lib/byterover
    rm $out/lib/byterover/bin/node
    cat > "$out/bin/brv" << EOF
    #!${stdenv.shell}
    export BRV_BINPATH="$out/lib/byterover/bin"
    export BRV_DISABLE_AUTOUPDATE=1
    export BRV_REDIRECTED=1
    exec ${nodejs_24}/bin/node "$out/lib/byterover/bin/run.js" "\$@"
    EOF
    chmod +x $out/bin/brv
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Portable memory layer for AI coding agents";
    homepage = "https://byterover.dev";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.elastic20;
    platforms = lib.attrNames finalAttrs.passthru.srcHashes;
    maintainers = with lib.maintainers; [ knightfemale ];
    mainProgram = "brv";
  };
})
