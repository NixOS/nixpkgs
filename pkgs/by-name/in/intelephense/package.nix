{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "1.14.2";
in
buildNpmPackage {
  pname = "intelephense";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/intelephense/-/intelephense-${version}.tgz";
    hash = "sha256-zb6u5zMsKc8H3IVqUAMiCSYqlM+RKOK3upKz1RKYEX0=";
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
