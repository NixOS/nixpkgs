{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  fetchurl,
  makeBinaryWrapper,
  nodejs,
  pnpmConfigHook,
  pnpm_11,
  stdenv,
  versionCheckHook,
  yarn-berry,
  plugins ? [ ],
}:
let
  pnpm = pnpm_11;

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

  yarnHash = "sha256-ajQyBhLRBuU53PCbad0bEeVO+kJlg0OpfkPsXX5RtJ8=";

  prettier-oxc-wasm-parser = stdenv.mkDerivation (finalAttrs: {
    pname = "binding-wasm32-wasi";
    version = "0.139.0";

    src = fetchurl {
      url = "https://registry.npmjs.org/@oxc-parser/${finalAttrs.pname}/-/${finalAttrs.pname}-${finalAttrs.version}.tgz";
      sha256 = "sha256-mQYWVK52hHi3gsXKpPxK7liQEg16wxKjY2hjkX9NPZE=";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    patches = [
      ./pnpm-lock_prettier-oxc-wasm-parser.patch
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        patches
        ;

      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-Vv6iiYCr/DS6sdQXaykeoPRbbqOVaVq2l8PK72mFjvo=";
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
      license = lib.licenses.mit;
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier";
  version = "3.10.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "prettier";
    repo = "prettier";
    tag = finalAttrs.version;
    hash = "sha256-ZL5qQU7TGGChzHYPSwYbUlhRGu+TTcD/NwHkXuI4mPI=";
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

    yarn config unset yarnPath
    yarn install --immutable

    mkdir -p .tmp/prettier-oxc-wasm-parser/node_modules/@oxc-parser

    cp -r ${prettier-oxc-wasm-parser.out} .tmp/prettier-oxc-wasm-parser/node_modules/@oxc-parser/binding-wasm32-wasi

    find .tmp/prettier-oxc-wasm-parser -type f -exec chmod u+w {} \;
    find .tmp/prettier-oxc-wasm-parser -type d -exec chmod u+w {} \;

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
