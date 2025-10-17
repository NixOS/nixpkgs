/**
  # Example

  Prettier with plugins and Vim Home Manager configuration

  ```nix
  pkgs.prettier.override {
    plugins = with pkgs.nodePackages; [
      prettier-plugin-toml
      # ...
    ];
  }
  ```
*/
{
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nodejs,
  stdenv,
  versionCheckHook,
  yarn-berry,
  plugins ? [ ],
}:
let
  /**
    # Example

    ```nix
    exportRelativePathOf (builtins.fromJSON "./package.json")
    =>
    lib/node_modules/prettier-plugin-toml/./lib/index.cjs
    ```

    # Type

    ```
    exportRelativePathOf :: AttrSet => String
    ```

    # Arguments

    packageJsonAttrs
    : Attribute set with shape similar to `package.json` file
  */
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

  /**
    # Example

    ```nix
    nodeEntryPointOf pkgs.nodePackages.prettier-plugin-toml
    =>
    /nix/store/<NAR_HASH>-prettier-plugin-toml-<VERSION>/lib/node_modules/prettier-plugin-toml/./lib/index.cjs
    ```

    # Type

    ```
    nodeEntryPointOf :: AttrSet => String
    ```

    # Arguments

    plugin
    : Attribute set with `.packageName` and `.outPath` defined
  */
  nodeEntryPointOf =
    plugin:
    let
      pluginDir = "${plugin.outPath}/lib/node_modules/${plugin.packageName}";

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
        ${plugin.packageName}: error context, tried finding entry point under;
        pathAbsoluteNaive -> ${pathAbsoluteNaive}
        pathAbsoluteFallback -> ${pathAbsoluteFallback}
      '' throw ''${plugin.packageName}: does not provide parse-able entry point'';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "prettier";
    repo = "prettier";
    tag = finalAttrs.version;
    hash = "sha256-uMLRFBZP7/42R6nReONcb9/kVGCn3yGHLcLFajMZLmQ=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-dpxzbtWyXsHS6tH6DJ9OqSsUSc+YqYeAPJYb95Qy5wQ=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  installPhase = ''
    runHook preInstall

    yarn install --immutable
    yarn build --clean

    cp --recursive dist/prettier "$out"

    makeBinaryWrapper "${lib.getExe nodejs}" "$out/bin/prettier" \
      --add-flags "$out/bin/prettier.cjs"
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
  versionCheckProgramArg = "--version";

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
