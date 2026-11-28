{
  lib,
  buildNpmPackage,
  fetchurl,
}:
let
  version = "1.18.5";
in
buildNpmPackage {
  pname = "intelephense";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/intelephense/-/intelephense-${version}.tgz";
    hash = "sha256-nJRd/uwvAwEI2jTJwdnmxpLP1dDPWTPxO4ZR97n5Q/E=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-HIDovjG0VrHH5Lx3ED0h/ZDFfjyYq599gyTuYtFwb0Y=";

  dontNpmBuild = true;

  meta = {
    description = "Professional PHP tooling for any Language Server Protocol capable editor";
    homepage = "https://intelephense.com/";
    license = lib.licenses.unfree;
    mainProgram = "intelephense";
    maintainers = with lib.maintainers; [ patka ];
  };
}
