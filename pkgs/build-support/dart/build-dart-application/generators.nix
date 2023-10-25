{ lib
, stdenvNoCC
, dart
, dartHooks
, yq
, cacert
}:

{
  # Commands to run once before using Dart or pub.
  sdkSetupScript ? ""
  # Arguments used in the derivation that builds the Dart package.
  # Passing these is recommended to ensure that the same steps are made to
  # prepare the sources in both this derivation and the one that builds the Dart
  # package.
, buildDrvArgs ? { }
, ...
}@args:

# This is a fixed-output derivation and setup hook that can be used to fetch dependencies for Dart projects.
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

  buildDrvInheritArgs = builtins.foldl'
    (attrs: arg:
      if buildDrvArgs ? ${arg}
      then attrs // { ${arg} = buildDrvArgs.${arg}; }
      else attrs)
    { }
    buildDrvInheritArgNames;

  drvArgs = buildDrvInheritArgs // (removeAttrs args [ "buildDrvArgs" ]);
  name = (if drvArgs ? name then drvArgs.name else "${drvArgs.pname}-${drvArgs.version}");

  mkDepsDrv = { pubspecLockFile, pubspecLockData, packageConfig }: args: stdenvNoCC.mkDerivation (drvArgs // args // {
    inherit pubspecLockFile packageConfig;

    nativeBuildInputs = drvArgs.nativeBuildInputs or [ ] ++ args.nativeBuildInputs or [ ] ++ [ dart dartHooks.dartConfigHook ];

    preConfigure = drvArgs.preConfigure or "" + args.preConfigure or "" + ''
      ln -sf "$pubspecLockFilePath" pubspec.lock
    '';

    passAsFile = drvArgs.passAsFile or [ ] ++ args.passAsFile or [ ] ++ [ "pubspecLockFile" ];
  } // (removeAttrs buildDrvInheritArgs [ "name" "pname" ]));

  mkDepsList = args: mkDepsDrv args {
    name = "${name}-dart-deps-list.json";

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      cp deps.json "$out"
      runHook postInstall
    '';
  };
in
{
  inherit
    mkDepsList;
}
