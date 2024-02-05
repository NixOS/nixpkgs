{ appium-unwrapped
, nodePackages
, stdenvNoCC
, nodejs
, makeWrapper
, yq-go
, lib
  # default to the 2 most used drivers
, drivers ? with nodePackages; [ appium-uiautomator2-driver appium-xcuitest-driver ]
, plugins ? []
, callPackage
}:
let
  allExtensions = drivers ++ plugins;
  extPath = ext: "${ext}/lib/node_modules/${ext.packageName}";
  extensionPaths = map extPath allExtensions;
in
stdenvNoCC.mkDerivation {
  pname = "appium";
  inherit (appium-unwrapped) version;

  dontUnpack = true;
  dontConfigure = true;
  dontPatch = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper nodejs ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/node_modules/.cache/appium

    # appium stores a "registry" of the installed drivers & plugins in $APPIUM_HOME/node_modules/.cache/appium/extensions.yaml
    # It would be prettier to let appium generate that file during build, but thats currently not really possible
    node ${./build-extensions-yaml.mjs} ${lib.concatStringsSep " " extensionPaths} > $out/node_modules/.cache/appium/extensions.yaml

    makeWrapper ${appium-unwrapped}/bin/appium $out/bin/appium \
      --set APPIUM_HOME $out

    runHook postInstall
  '';

  passthru.tests.ensure-drivers = callPackage ./test.nix {};

  inherit (appium-unwrapped) meta;
}
