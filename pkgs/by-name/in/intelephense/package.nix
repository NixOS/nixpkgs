{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "1.14.1";
in
buildNpmPackage {
  pname = "intelephense";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/intelephense/-/intelephense-${version}.tgz";
    hash = "sha256-6TT8RYg6l6Vcua0t5Mn+N/t5FehmY9nOxYAgvSFOre8=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-FNafLqlyGopWShr0Ltw1YqaY/Ik9TAT8oHO6tQBTiQc=";

  dontNpmBuild = true;

  meta = {
    description = "Professional PHP tooling for any Language Server Protocol capable editor";
    homepage = "https://intelephense.com/";
    license = lib.licenses.unfree;
    mainProgram = "intelephense";
    maintainers = with lib.maintainers; [ patka ];
  };
}
