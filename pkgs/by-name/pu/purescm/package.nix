{
  lib,
  buildNpmPackage,
  fetchNpmDeps,
  testers,
}:

let
  inherit (lib) fileset;

  packageLock = builtins.fromJSON (builtins.readFile ./manifests/package-lock.json);

  pname = "purescm";
  version = packageLock.packages."node_modules/${pname}".version;

  package = buildNpmPackage {
    inherit pname version;

    src = ./manifests;
    dontNpmBuild = true;

    npmDeps = fetchNpmDeps {
      src = ./manifests;
      hash = "sha256-ljeFcLvIET77Q0OR6O5Ok1fGnaxaKaoywpcy2aHq/6o=";
    };

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
