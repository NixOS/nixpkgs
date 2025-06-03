{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "1.14.4";
in
buildNpmPackage {
  pname = "intelephense";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/intelephense/-/intelephense-${version}.tgz";
    hash = "sha256-vFXwkFPmgEbB2RtB0lxT6UaZMxaWXh+3BHCL9+1rRjk=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-UFtJRYKk3unStsdoOa6Dwn41KnaDxdWXTNBcIQkZaLI=";

  dontNpmBuild = true;

  meta = {
    description = "Professional PHP tooling for any Language Server Protocol capable editor";
    homepage = "https://intelephense.com/";
    license = lib.licenses.unfree;
    mainProgram = "intelephense";
    maintainers = with lib.maintainers; [ patka ];
  };
}
