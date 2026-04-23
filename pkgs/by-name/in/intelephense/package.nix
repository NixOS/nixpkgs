{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "1.16.5";
in
buildNpmPackage {
  pname = "intelephense";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/intelephense/-/intelephense-${version}.tgz";
    hash = "sha256-Qqc5canlBafwCeLxquT+K3MdH5SqdZVuYBZNfinAXIk=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-BKnv65e+BgJrBKQ2J1glvfbd0Gt3BF9shgGDk9cNWcQ=";

  dontNpmBuild = true;

  meta = {
    description = "Professional PHP tooling for any Language Server Protocol capable editor";
    homepage = "https://intelephense.com/";
    license = lib.licenses.unfree;
    mainProgram = "intelephense";
    maintainers = with lib.maintainers; [ patka ];
  };
}
