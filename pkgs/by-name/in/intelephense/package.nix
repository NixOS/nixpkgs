{
  lib,
  buildNpmPackage,
  fetchurl,
  nix-update-script,
}:
let
  version = "1.12.6";
in
buildNpmPackage {
  pname = "intelephense";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/intelephense/-/intelephense-${version}.tgz";
    hash = "sha256-p2x5Ayipoxk77x0v+zRhg86dbRHuBBk1Iegk/FaZrU4=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-C60qxPuaiJZ8uQDfDwY+KJUHhXMioPrHnDNJ0bH7N9o=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Professional PHP tooling for any Language Server Protocol capable editor";
    homepage = "https://intelephense.com/";
    license = lib.licenses.unfree;
    mainProgram = "intelephense";
    maintainers = with lib.maintainers; [ patka ];
  };
}
