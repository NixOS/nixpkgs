{
  lib,
  stdenvNoCC,
  autopen,
}:

let
  inherit (lib)
    concatMap
    concatMapStringsSep
    extendMkDerivation
    isAttrs
    isDerivation
    match
    splitStringBy
    substring
    toLower
    toUpper
    ;

  inherit (lib.generators)
    mkValueStringDefault
    ;

  inherit (lib.cli)
    toCommandLine
    ;

  inherit (autopen.internal)
    mkCliDerivationBuilder
    ;

  splitCamelCase = splitStringBy (_prev: curr: match "[A-Z]" curr != null) true;

  toKebabCase = camelCase: concatMapStringsSep "-" toLower (splitCamelCase camelCase);

  optionFormat = optionName: {
    option = "--${toKebabCase optionName}";
    sep = "=";
    explicitBool = false;
  };
in
{
  mkCliDerivationBuilder =
    {
      package,
      exe,
      attrPrefix,
    }:
    extendMkDerivation {
      constructDrv = stdenvNoCC.mkDerivation;

      extendDrvArgs =
        finalAttrs:
        {
          nativeBuildInputs ? [ ],
          ...
        }@args:
        {
          nativeBuildInputs = [ package ] ++ nativeBuildInputs;

          buildCommand = ''
            runHook "pre$hookName"

            echoCmd "$exeName flags" "''${exeFlags[@]}"
            "$exe" "''${exeFlags[@]}"

            runHook "post$hookName"
          '';

          inherit exe;

          exeName = baseNameOf exe;

          exeFlags = concatMap (
            component:
            if isAttrs component && !isDerivation component then
              toCommandLine optionFormat component
            else
              [ (mkValueStringDefault { } component) ]
          ) args."${attrPrefix}Args";

          hookName = toUpper (substring 0 1 attrPrefix) + substring 1 (-1) attrPrefix;

          strictDeps = true;

          __structuredAttrs = true;
        };
    };

  mkAutopenDerivation = mkCliDerivationBuilder {
    package = autopen;
    exe = "autopen";
    attrPrefix = "autopen";
  };

  /**
    Hide a derivation’s internals.

    This is used to abstract away implementation details so that
    secret capabilities used at build time don’t trivially leak out of
    a derivation to consumers of its outputs.

    Note that pulling `drv.drvPath` pulls in the transitive build
    dependency closure of `drv`, including built outputs, so this is
    not foolproof. Hiding `drvPath` wouldn’t solve this, as any
    derivation that uses the output of `drv` would itself have a
    `drvPath` that behaves the same way. Therefore, this should
    unfortunately be considered a best‐effort approach under current
    Nix semantics.

    # Inputs

    `drv`
    : The derivation to hide the internals of.

    # Type

    ```
    hideDerivation :: Derivation -> Derivation
    ```
  */
  hideDerivation =
    drv:
    assert isDerivation drv && drv.outputs == [ "out" ];
    let
      hiddenDrv = {
        inherit (drv)
          type
          name
          system
          outPath
          drvPath
          outputs
          outputName
          strictDeps
          __structuredAttrs
          passthru
          meta
          ;

        out = hiddenDrv;
        all = [ hiddenDrv ];
      }
      // drv.passthru;
    in
    hiddenDrv;
}
