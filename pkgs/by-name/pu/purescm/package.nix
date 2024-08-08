{ lib
, buildNpmPackage
, importNpmLock
, testers
}:

let
  inherit (lib) fileset;

  packageLock = builtins.fromJSON (builtins.readFile ./package-lock.json);

  pname = "purescm";
  version = packageLock.packages."node_modules/${pname}".version;

  package = buildNpmPackage {
    inherit pname version;

    src = fileset.toSource {
      root = ./.;
      fileset = fileset.unions [
        ./package.json
        ./package-lock.json
        ./.gitignore
      ];
    };
    dontNpmBuild = true;

    npmDeps = importNpmLock { npmRoot = ./.; };
    npmConfigHook = importNpmLock.npmConfigHook;

    installPhase = ''
      mkdir -p $out/share/${pname}
      cp -r node_modules/ $out/share/${pname}
      ln -s $out/share/${pname}/node_modules/.bin $out/bin
    '';

    passthru.tests = {
      version = testers.testVersion { inherit package; };
    };

    meta = {
      description = "Chez Scheme back-end for PureScript";
      homepage = "https://github.com/purescm/purescm";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ toastal ];
      mainProgram = "purescm";
    };
  };
in
package
