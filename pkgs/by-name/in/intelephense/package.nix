{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "1.16.1";
in
buildNpmPackage {
  pname = "intelephense";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/intelephense/-/intelephense-${version}.tgz";
    hash = "sha256-hbKl0kCdqGnVMJvGeWgz8ivQnpS9qzyLUwToQQQ7uMY=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-gzalO/qXD2ZXXeb3FmzIWBbHpeBrQcNcu2j4udmsZvc=";

  dontNpmBuild = true;

  meta = {
    description = "Professional PHP tooling for any Language Server Protocol capable editor";
    homepage = "https://intelephense.com/";
    license = lib.licenses.unfree;
    mainProgram = "intelephense";
    maintainers = with lib.maintainers; [ patka ];
  };
}
