{
  lib,
  buildNpmPackage,
  fetchurl,
  nix-update-script,
}:
let
  version = "1.12.5";
in
buildNpmPackage {
  pname = "intelephense";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/intelephense/-/intelephense-${version}.tgz";
    hash = "sha256-S2wlzEDSKu/7NxnFMAj25meXzW37fGbH1ztCbWDRAqc=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-HpJYDPPX5elvd0SMCJuTu5j4v1caO25UZqywB2huUAA=";

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
