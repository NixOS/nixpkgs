{
  lib,
  stdenv,
  bun,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  nodejs,
  patchelf,
  python3,
  removeReferencesTo,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  node-modules-hash = {
    "aarch64-darwin" = "sha256-z5PS0kaizEJdzTRcIH8X60Ozmteq4tx5w7SdYYMgCPI=";
    "aarch64-linux" = "sha256-HTSOjo+8jRmCCeBVujpIAqROTpVEVq1UKM+v3urphfU=";
    "x86_64-darwin" = "sha256-2CRtIKNqy7axoZ9ZsBrzQlkkPGbEDR3khdd56ltzak4=";
    "x86_64-linux" = "sha256-WDpj1VSs/JI+9mr7LRWE054iiBRfRD75aRj90E23kYw=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kulala-fmt";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "mistweaverco";
    repo = "kulala-fmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cjZaE0iz/Km9bJA58HP9MoZRUFEHs7af1vJttK6wUIY=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      nodejs
      python3
      writableTmpDirAsHomeHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      patchelf
      removeReferencesTo
    ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      export npm_config_nodedir=${nodejs}
      bun install --frozen-lockfile --no-progress --no-cache
      find node_modules -type f -name "*.node" -exec sh -c \
        'for binary in "$@"; do strip -S "$binary" 2>/dev/null || true; done' sh {} +
      rm -f node_modules/lodash/flake.lock
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        find node_modules -type f -name "*.node" -exec sh -c \
          'for binary in "$@"; do patchelf --remove-rpath "$binary" 2>/dev/null || true; done' sh {} +
        find node_modules/@mistweaverco -type f -name "*.node" -exec patchelf --set-rpath "" {} \;
        find node_modules/@mistweaverco -type f -name "*.node" -exec remove-references-to \
          -t "$out" \
          -t "${stdenv.cc.libc}" \
          -t "${stdenv.cc.cc.lib}" \
          {} \;
      ''}
      rm -rf \
        node_modules/@mistweaverco/node-addon-api/*.target.mk \
        node_modules/@mistweaverco/tree-sitter-kulala/build/Makefile \
        node_modules/@mistweaverco/tree-sitter-kulala/build/config.gypi \
        node_modules/@mistweaverco/tree-sitter-kulala/build/*.target.mk \
        node_modules/@mistweaverco/tree-sitter-kulala/build/Release/.deps \
        node_modules/@mistweaverco/tree-sitter-kulala/build/Release/obj.target

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    outputHash =
      node-modules-hash.${stdenv.hostPlatform.system}
        or (throw "${finalAttrs.pname}: Platform ${stdenv.hostPlatform.system} is not packaged yet. Supported platforms: ${lib.concatStringsSep ", " (builtins.attrNames node-modules-hash)}.");
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
    nodejs
  ];

  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    cp -R ${finalAttrs.node_modules}/node_modules .
    patchShebangs node_modules

    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/${finalAttrs.pname}/node_modules/@mistweaverco
    cp -R dist package.json $out/lib/${finalAttrs.pname}/
    cp -R node_modules/{node-addon-api,node-gyp-build,prettier,tree-sitter} \
      $out/lib/${finalAttrs.pname}/node_modules/
    cp -R node_modules/@mistweaverco/tree-sitter-kulala \
      $out/lib/${finalAttrs.pname}/node_modules/@mistweaverco/

    makeBinaryWrapper ${nodejs}/bin/node $out/bin/${finalAttrs.pname} \
      --add-flags $out/lib/${finalAttrs.pname}/dist/cli.cjs \
      --set NODE_ENV production

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Opinionated .http and .rest files linter and formatter";
    homepage = "https://github.com/mistweaverco/kulala-fmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CnTeng ];
    mainProgram = "kulala-fmt";
    platforms = builtins.attrNames node-modules-hash;
  };
})
