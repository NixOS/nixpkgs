{
  callPackage,
  runCommand,

  kalamine,
  lib,
}:
let
  sumfile =
    angle: intl:
    runCommand
      "kalamine-sumfile${lib.optionalString angle "-angle"}${lib.optionalString intl "-q-intl"}.sum"
      { }
      ''
        ${lib.getExe kalamine} build ${lib.optionalString angle "--angle-mod"} ${kalamine.src}/layouts/${if intl then "intl" else "*"}.toml
        cd dist
        sha256sum * > $out
      '';

  baseDerivation =
    {
      kalamine, # needs to be overriden in case something overrides it
      stdenvNoCC,

      src,
      pname-suffix ? "",
      angleMod ? false,
      onlyIntl ? false,
      dontUnpack ? false,
    }:
    stdenvNoCC.mkDerivation (finalAttrs: {
      __structuredAttrs = true;

      inherit (kalamine) version;
      pname = "kalamine-setuphook-test${pname-suffix}";

      inherit src dontUnpack;

      kalamineBuildArgs = lib.optionals angleMod [ "--angle-mod" ];
      nativeBuildInputs = [ kalamine ];

      doCheck = true;
      checkPhase = ''
        (cd dist && sha256sum --strict -c "${sumfile angleMod onlyIntl}")
      '';
    });

  # only q-intl supports the angle mod, hence why we use it for tests
  singleLayout = "${kalamine.src}/layouts/intl.toml";
  layoutDir = "${kalamine.src}/layouts";

  layoutDirPkg =
    angle:
    (kalamine.fromDir layoutDir (
      { name = "test"; } // (lib.optionalAttrs angle { args = [ "--angle-mod" ]; })
    ));

  mkSingleTest =
    sfx: layout: angle:
    let
      layoutPkg = kalamine.fromLayout layout (lib.optionalAttrs angle { args = [ "--angle-mod" ]; });
    in
    runCommand "kalamine-function-test-${sfx}" { } ''
      cd ${layoutPkg}
      sha256sum --strict -c ${sumfile angle true}
      touch $out
    '';

  mkFunctionsWithDirTest =
    angle:
    runCommand "kalamine-function-wDir-test${lib.optionalString angle "-angle"}" { } ''
      cd ${layoutDirPkg angle}
      sha256sum --strict -c ${sumfile angle false}
      touch $out
    '';
in
rec {
  withFile = callPackage baseDerivation {
    inherit kalamine;
    src = "${kalamine.src}/layouts/intl.toml";
    pname-suffix = "withFile";
    onlyIntl = true;
    dontUnpack = true;
  };
  withFile-angle = withFile.override {
    angleMod = true;
    pname-suffix = "withFile-angle";
  };

  withDir = callPackage baseDerivation {
    inherit kalamine;
    src = "${kalamine.src}/layouts";
    pname-suffix = "withDir";
  };

  withDir-angle = withDir.override {
    angleMod = true;
    pname-suffix = "withDir-angle";
  };

  withDir-sourceRoot = callPackage (
    {
      kalamine,
      stdenvNoCC,
    }:
    stdenvNoCC.mkDerivation (finalAttrs: {
      __structuredAttrs = true;

      inherit (kalamine) version src;
      sourceRoot = "${finalAttrs.src.name}/layouts";
      pname = "kalamine-setuphook-test-with-sourceRoot";

      nativeBuildInputs = [ kalamine ];

      doCheck = true;
      checkPhase = ''
        (cd dist && sha256sum --strict -c "${sumfile false false}")
      '';
    })
  ) { inherit kalamine; };

  functionsWithFile = mkSingleTest "file" singleLayout false;
  functionsWithFile-angle = mkSingleTest "file-angle" singleLayout true;
  functionsWithTOMLvar = mkSingleTest "TOML-var" (builtins.readFile singleLayout) false;
  functionsWithAttrset = mkSingleTest "attrset" (fromTOML (builtins.readFile singleLayout)) false;

  functionsWithDir = mkFunctionsWithDirTest false;
  functionsWithDir-angle = mkFunctionsWithDirTest true;
}
