{
  lib,
  stdenv,
  bun,
  fetchFromGitHub,
  kulala-core,
  makeBinaryWrapper,
  nodejs,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kulala-fmt";
  version = "3.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mistweaverco";
    repo = "kulala-fmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4rVsw3dyoKrC6lj8m2R42iZmBk5G2LIVtV6Ro9pHSBo=";
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

    outputHash = "sha256-z+jQC2RCav3VG/agWizcWFat8KgkGdBzaGQriviEbyo=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
    nodejs
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    cp -R ${finalAttrs.node_modules}/node_modules .
    patchShebangs node_modules
    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/cli.cjs $out/lib/kulala-fmt/cli.cjs
    makeBinaryWrapper ${lib.getExe nodejs} $out/bin/kulala-fmt \
      --add-flags $out/lib/kulala-fmt/cli.cjs \
      --set KULALA_CORE_PATH ${lib.getExe kulala-core}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/kulala-fmt --version | grep -x ${lib.escapeShellArg finalAttrs.version}
    printf '%s\n' 'GET https://example.com' | $out/bin/kulala-fmt format --stdin | grep 'GET https://example.com'

    runHook postInstallCheck
  '';

  meta = {
    description = "Opinionated .http and .rest files linter and formatter";
    homepage = "https://github.com/mistweaverco/kulala-fmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CnTeng ];
    mainProgram = "kulala-fmt";
    platforms = nodejs.meta.platforms;
  };
})
