{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  makeBinaryWrapper,
  nodejs,
  pnpmConfigHook,
  pnpm_9,
  stdenv,
  versionCheckHook,
  yarn-berry,
  plugins ? [ ],
}:
let
  ## Blame NodeJS
  exportRelativePathOf =
    let
      nodeExportAttrAddresses = [
        [ "main" ]
        [
          "exports"
          "."
          "default"
        ]
        [
          "exports"
          "."
        ]
        [
          "exports"
          "default"
        ]
        [ "exports" ]
      ];

      recAttrByPath =
        addresses: default: attrs:
        if builtins.length addresses == 0 then
          default
        else
          let
            addressNext = builtins.head addresses;
            addressesRemaning = lib.lists.drop 1 addresses;
          in
          lib.attrByPath addressNext (recAttrByPath addressesRemaning default attrs) attrs;
    in
    packageJsonAttrs:
    recAttrByPath nodeExportAttrAddresses (builtins.head (
      lib.attrByPath [ "prettier" "plugins" ] [ "null" ] packageJsonAttrs
    )) packageJsonAttrs;

  nodeEntryPointOf =
    plugin:
    let
      pluginDir = "${plugin.outPath}/lib/node_modules/${plugin.pname}";

      packageJsonAttrs = builtins.fromJSON (builtins.readFile "${pluginDir}/package.json");

      exportPath = exportRelativePathOf packageJsonAttrs;

      pathAbsoluteNaive = "${pluginDir}/${exportPath}";
      pathAbsoluteFallback = "${pluginDir}/${exportPath}.js";
    in
    if builtins.pathExists pathAbsoluteNaive then
      pathAbsoluteNaive
    else if builtins.pathExists pathAbsoluteFallback then
      pathAbsoluteFallback
    else
      lib.warn ''
        ${plugin.pname}: error context, tried finding entry point under;
        pathAbsoluteNaive -> ${pathAbsoluteNaive}
        pathAbsoluteFallback -> ${pathAbsoluteFallback}
      '' throw "${plugin.pname}: does not provide parse-able entry point";

  yarnHash = "sha256-WncAReGKs9cZvPTf87bKKOrmte5ORyHOb5pTAgHsb8M=";

  prettier-oxc-wasm-parser = stdenv.mkDerivation (finalAttrs: {
    pname = "binding-wasm32-wasi";
    version = "0.99.0";

    src = builtins.fetchTarball {
      url = "https://registry.npmjs.org/@oxc-parser/${finalAttrs.pname}/-/${finalAttrs.pname}-${finalAttrs.version}.tgz";
      sha256 = "05ndf32qlx5qnrp0r4jrgb8219mihvha68b1jcvk24ys76gpmxpm";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_9
    ];

    prePnpmInstall = ''
      install --mode=644 -T ${./pnpm-lock_prettier-oxc-wasm-parser.yaml} ./pnpm-lock.yaml
    '';

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        prePnpmInstall
        ;

      pnpm = pnpm_9;
      fetcherVersion = 2;
      hash = "sha256-i3zxUTy8vRo+Scn+ZQkZ2/j9emjurCNR4Cz8C8XsHjQ=";
    };

    buildPhase = ''
      runHook preBuild
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r . $out/

      runHook postInstall
    '';

    doCheck = false;
    doInstallCheck = false;

    meta = {
      description = "Oxc Parser Node API";
      homepage = "https://oxc.rs/docs/guide/usage/parser";
      license = "MIT";
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "prettier";
    repo = "prettier";
    tag = finalAttrs.version;
    hash = "sha256-SzrpkWyT/Vdt21KUQ0cTQ0QmCivazY6rrgmApsvXZWs=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = yarnHash;
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  installPhase = ''
    runHook preInstall

    yarn install --immutable

    mkdir -p .tmp/prettier-oxc-wasm-parser/node_modules/@oxc-parser

    cp -r ${prettier-oxc-wasm-parser.out} .tmp/prettier-oxc-wasm-parser/node_modules/@oxc-parser/binding-wasm32-wasi

    find .tmp/prettier-oxc-wasm-parser -type f -exec chmod u+w {} \;
    find .tmp/prettier-oxc-wasm-parser -type d -exec chmod u+w {} \;

    sed --in-place --expression '/^\s\+const installDirectory = await install(version);$/ {
      s#await install(version)#new URL("../../.tmp/prettier-oxc-wasm-parser", import.meta.url)#;
    }' scripts/build/build-oxc-wasm-parser.js

    yarn build --clean

    mkdir -p $out/lib/node_modules
    cp --recursive dist/prettier "$out/lib/node_modules/prettier"

    makeBinaryWrapper "${lib.getExe nodejs}" "$out/bin/prettier" \
      --add-flags "$out/lib/node_modules/prettier/bin/prettier.cjs"
  ''
  + lib.optionalString (builtins.length plugins > 0) ''
    wrapProgram $out/bin/prettier --add-flags "${
      builtins.concatStringsSep " " (lib.map (plugin: "--plugin=${nodeEntryPointOf plugin}") plugins)
    }";
  ''
  + ''
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/prettier/prettier/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Code formatter";
    homepage = "https://prettier.io/";
    license = lib.licenses.mit;
    mainProgram = "prettier";
    maintainers = with lib.maintainers; [
      l0b0
      S0AndS0
    ];
  };
})
