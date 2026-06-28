{
  lib,
  stdenv,
  bun,
  curl,
  fetchFromGitHub,
  makeWrapper,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kulala-core";
  version = "0.14.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mistweaverco";
    repo = "kulala-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1EtYAKulMQbtYWHZ8MkUA1fMcL3V07/Sz1sjl5PnaI4=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    strictDeps = true;
    __structuredAttrs = true;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R node_modules $out/

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-XQlBawD3vt8pVc7Gy9XeiGie89HWbljNJt7kUEDaDKk=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    makeWrapper
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    cp -R ${finalAttrs.node_modules}/node_modules .
    echo '{ "version": "${finalAttrs.version}" }' > packages/core/version.json
    (
      cd packages/core
      bun build src/cli.ts \
        --target=bun \
        --outdir=dist \
        --asset-naming='[name].[ext]'
    )

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 packages/core/dist/cli.js $out/lib/kulala-core/kulala-core.js
    install -Dm644 packages/core/dist/liblua5.1.wasm $out/lib/kulala-core/liblua5.1.wasm
    makeWrapper ${lib.getExe bun} $out/bin/kulala-core \
      --add-flags $out/lib/kulala-core/kulala-core.js \
      --set KULALA_CURL_PATH ${lib.getExe curl}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    kulalaResponse=$(
      printf '%s' '{"action":"from_curl","curl":"curl https://example.com"}' | \
        $out/bin/kulala-core
    )
    [[ "$kulalaResponse" = *'"ok": true'* ]]
    [[ "$kulalaResponse" = *'GET https://example.com'* ]]

    runHook postInstallCheck
  '';

  meta = {
    description = "HTTP client library powering the Kulala toolchain";
    homepage = "https://github.com/mistweaverco/kulala-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "kulala-core";
    platforms = bun.meta.platforms;
  };
})
