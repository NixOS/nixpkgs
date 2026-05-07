{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "1.18.1";
in
buildNpmPackage {
  pname = "intelephense";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/intelephense/-/intelephense-${version}.tgz";
    hash = "sha256-GkjSPm54lAzaPb/Z31Gng+EZCuxXF8ys1YtKmRkSSpc=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-U3q2Suf9FxroXnDg8NcW186hGbcpE4UQGgHqD5n6/MM=";

  dontNpmBuild = true;

  meta = {
    description = "Professional PHP tooling for any Language Server Protocol capable editor";
    homepage = "https://intelephense.com/";
    license = lib.licenses.unfree;
    mainProgram = "intelephense";
    maintainers = with lib.maintainers; [ patka ];
  };
}
