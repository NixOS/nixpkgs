{
  lib,
  stdenvNoCC,
  dart,
  dartHooks,
  jq,
  yq,
  cacert,
}:

{
  # Arguments used in the derivation that builds the Dart package.
  # Passing these is recommended to ensure that the same steps are made to
  # prepare the sources in both this derivation and the one that builds the Dart
  # package.
  buildDrvArgs ? { },
  ...
}@args:

# This is a derivation and setup hook that can be used to fetch dependencies for Dart projects.
# It is designed to be placed in the nativeBuildInputs of a derivation that builds a Dart package.
# Providing the buildDrvArgs argument is highly recommended.
let
  buildDrvInheritArgNames = [
    "name"
    "pname"
    "version"
    "src"
    "sourceRoot"
    "setSourceRoot"
    "preUnpack"
    "unpackPhase"
    "unpackCmd"
    "postUnpack"
    "prePatch"
    "patchPhase"
    "patches"
    "patchFlags"
    "postPatch"
  ];

  buildDrvInheritArgs = builtins.foldl' (
    attrs: arg: if buildDrvArgs ? ${arg} then attrs // { ${arg} = buildDrvArgs.${arg}; } else attrs
  ) { } buildDrvInheritArgNames;

  drvArgs = buildDrvInheritArgs // (removeAttrs args [ "buildDrvArgs" ]);
  name = (if drvArgs ? name then drvArgs.name else "${drvArgs.pname}-${drvArgs.version}");

  # Adds the root package to a dependency package_config.json file from pub2nix.
  linkPackageConfig =
    {
      pubspecLock,
      packageConfig,
      extraSetupCommands ? "",
    }:
    stdenvNoCC.mkDerivation (
      drvArgs
      // {
        name = "${name}-package-config-with-root.json";

        nativeBuildInputs =
          drvArgs.nativeBuildInputs or [ ]
          ++ args.nativeBuildInputs or [ ]
          ++ [
            jq
            yq
          ];

        dontBuild = true;

        installPhase =
          let
            m = builtins.match "^[[:space:]]*(\\^|>=|>)?[[:space:]]*([0-9]+\\.[0-9]+)\\.[0-9]+.*$" pubspecLock.sdks.dart;
            languageVersion =
              if m != null then
                (builtins.elemAt m 1)
              else if pubspecLock.sdks.dart == "any" then
                "null"
              else
                # https://github.com/dart-lang/pub/blob/15b96589066884300a30bdc356566f3398794857/lib/src/language_version.dart#L109
                "2.7";
          in
          ''
            runHook preInstall

            packageName="$(yq --raw-output .name pubspec.yaml)"
            jq --arg name "$packageName" --arg languageVersion ${languageVersion} '.packages |= . + [{ name: $name, rootUri: "../", packageUri: "lib/", languageVersion: (if $languageVersion == "null" then null else $languageVersion end) }]' '${packageConfig}' > "$out"
            ${extraSetupCommands}

            runHook postInstall
          '';
      }
    );
in
{
  inherit
    linkPackageConfig
    ;
}
