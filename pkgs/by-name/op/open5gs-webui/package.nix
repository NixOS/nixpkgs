{
  buildNpmPackage,
  open5gs,
}:

buildNpmPackage (finalAttrs: {
  pname = "${open5gs.pname}-webui";
  inherit (open5gs) src version meta;

  sourceRoot = "${finalAttrs.src.name}/webui";

  npmDepsHash = "sha256-Epz+pCbgejkj7vcdwbPC2RfAkp2HRqGV0urXiiBrjZQ=";
})
