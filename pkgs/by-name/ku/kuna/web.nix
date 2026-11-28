{
  stdenvNoCC,
  pkgsCross,
  buildPackages,
  binaryen,
  lld,
  python3,
  nodejs,
  kuna,
}:

let
  wasm = pkgsCross.wasm32-wasip1.rustPlatform.buildRustPackage {
    pname = "kuna-wasm";
    inherit (kuna)
      version
      src
      cargoDeps
      cargoRoot
      buildAndTestSubdir
      ;

    env = {
      KUNA_VERSION = kuna.version;
      RUSTFLAGS = "-C linker=${lld}/bin/wasm-ld";
    };
    cargoBuildFlags = [
      "-p"
      "kuna-wasm"
      "--bin"
      "kuna_wasm"
    ];

    # Exercise the WASI module through the web integration tests below.
    doCheck = false;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp target/wasm32-wasip1/release/kuna_wasm.wasm $out/
      runHook postInstall
    '';
  };
in
stdenvNoCC.mkDerivation {
  pname = "kuna-web";
  inherit (kuna) version src;

  __structuredAttrs = true;
  strictDeps = true;
  dontConfigure = true;

  nativeBuildInputs = [
    binaryen
    python3
  ];
  nativeCheckInputs = [ nodejs ];

  buildPhase = ''
    runHook preBuild
    cd integrations/web
    mkdir dist
    cp -r index.html compare-samples.js kuna-web.js kuna-worker.js \
      kuna-worker-client.js zip.js sha256.js assets decompile vendor dist/
    wasm-opt -Oz ${wasm}/kuna_wasm.wasm -o dist/kuna_wasm.wasm

    python3 - <<'PY'
    import base64, json, pathlib, shutil
    root = pathlib.Path("${buildPackages.kuna}/share/kuna/specs")
    small = {}
    for source in sorted(root.rglob("*")):
        if source.is_file() and source.suffix in {".ldefs", ".pspec", ".cspec", ".dwarf", ".sla"}:
            relative = source.relative_to(root)
            target = pathlib.Path("dist/specs") / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source, target)
            if source.suffix != ".sla":
                small[relative.as_posix()] = base64.b64encode(source.read_bytes()).decode("ascii")
    pathlib.Path("dist/specs-small.json").write_text(json.dumps(small, separators=(",", ":")))
    PY
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    node test/glue.mjs
    node test/worker.mjs
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r dist/. $out/
    runHook postInstall
  '';

  meta = {
    inherit (kuna.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "Browser interface for the Kuna binary decompiler";
  };
}
