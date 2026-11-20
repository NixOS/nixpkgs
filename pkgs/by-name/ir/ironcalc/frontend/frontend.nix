{
  buildNpmPackage,
  ironcalc,
}:
buildNpmPackage {
  pname = "ironcalc-frontend";
  inherit (ironcalc) version src;
  sourceRoot = "source";

  postPatch = ''
    cd webapp/app.ironcalc.com/frontend
    chmod -R u+w ../../..

    # wasm location fix
    mkdir -p ../../../bindings/wasm/pkg
    cp -rv ${ironcalc.wasm}/. ../../../bindings/wasm/pkg/

    rm -rf ../../IronCalc
    cp -r ${ironcalc.workbook} ../../IronCalc
    chmod -R u+w ../../IronCalc
  '';

  npmDepsHash = "sha256-MntYuLaw4svpAU+0JQE0GnKjLFfZnrdreUGbMdT2o+Y=";

  preBuild = ''
    # wasm resolution fix
    mkdir -p node_modules/@ironcalc
    cp -rv ${ironcalc.wasm}/. node_modules/@ironcalc/wasm
  '';

  installPhase = ''
    mkdir -p $out
    cp -r dist/. $out
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = ironcalc.meta // {
    description = "Ironcalc frontend package";
  };
}
