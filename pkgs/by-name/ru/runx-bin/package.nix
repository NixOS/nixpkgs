{
  fetchurl,
  lib,
  stdenvNoCC,
}:

let
  sources = {
    aarch64-darwin = {
      target = "aarch64-apple-darwin";
      hash = "sha256-cQbIn6bxgItdSBNN6UqT/mTn88y0fmA/EwWprRLwrsU=";
    };
    x86_64-darwin = {
      target = "x86_64-apple-darwin";
      hash = "sha256-CXarzd5pMq+cjGzVSMfpJ2OrrhI3iVbem4wWG5A8Vkw=";
    };
    aarch64-linux = {
      target = "aarch64-unknown-linux-musl";
      hash = "sha256-AYGCavw55JvKJvp/0tFsCNgW7JQiDJVTSB2cZV66cF0=";
    };
    x86_64-linux = {
      target = "x86_64-unknown-linux-musl";
      hash = "sha256-We7ir4HSTQ+LokFuK6xV0Uftk2k+akH/58LP1cupjMc=";
    };
  };
  source = sources.${stdenvNoCC.hostPlatform.system} or (throw "runx-bin: unsupported platform");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "runx-bin";
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/runxhq/runx/releases/download/cli-v${finalAttrs.version}/runx-${finalAttrs.version}-${source.target}.tar.gz";
    inherit (source) hash;
  };
  sourceRoot = "runx-${finalAttrs.version}-${source.target}";

  strictDeps = true;
  __structuredAttrs = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 runx "$out/bin/runx"
    install -Dm755 runx-js-worker "$out/bin/runx-js-worker"
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
        runHook preInstallCheck
        "$out/bin/runx" --version | grep -F "${finalAttrs.version}"
        mkdir -p "$TMPDIR/runx-smoke" "$TMPDIR/receipts"
        cat > "$TMPDIR/runx-smoke/SKILL.md" <<'EOF'
    ---
    name: nix-smoke
    description: Verify the installed Runx JavaScript worker.
    ---

    Run the packaging probe.
    EOF
        cat > "$TMPDIR/runx-smoke/X.yaml" <<'EOF'
    skill: nix-smoke
    runners:
      run:
        default: true
        type: javascript
        module: probe.mjs
        outputs:
          value: string
    EOF
        echo 'export default () => ({ value: "nix-worker-ok" });' > "$TMPDIR/runx-smoke/probe.mjs"
        HOME="$TMPDIR" "$out/bin/runx" skill "$TMPDIR/runx-smoke" --receipt-dir "$TMPDIR/receipts" --json > "$TMPDIR/runx-smoke.json"
        grep -F '"status":"sealed"' "$TMPDIR/runx-smoke.json"
        grep -F 'nix-worker-ok' "$TMPDIR/runx-smoke.json"
        runHook postInstallCheck
  '';

  meta = {
    description = "Governed runtime for agent skills";
    homepage = "https://runx.ai";
    license = lib.licenses.asl20;
    mainProgram = "runx";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
