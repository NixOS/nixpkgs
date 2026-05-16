{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "1.18.2";
in
buildNpmPackage {
  pname = "intelephense";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/intelephense/-/intelephense-${version}.tgz";
    hash = "sha256-9he4PwHY/ohSKVTlD11MOlcrB3ldAp6EWiIYJRMj2b0=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-gamhLTob6xyxwWRf61HwoemP1emuboVcdbltugISclE=";

  dontNpmBuild = true;

  meta = {
    description = "Professional PHP tooling for any Language Server Protocol capable editor";
    homepage = "https://intelephense.com/";
    license = lib.licenses.unfree;
    mainProgram = "intelephense";
    maintainers = with lib.maintainers; [ patka ];
  };
}
