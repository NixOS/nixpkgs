{
  lib,
  buildNpmPackage,
  grayjay,
}:

buildNpmPackage {
  pname = "${grayjay.pname}-frontend";

  # nixpkgs-update: no auto update
  inherit (grayjay) version src;

  sourceRoot = "source/Grayjay.Desktop.Web";

  __structuredAttrs = true;
  strictDeps = true;
  npmBuildScript = "build";
  npmDepsHash = "sha256-3yJIPkuEvkFL9Wb4y/r0yEULQbXx/wHqicFBLzOPj68=";

  installPhase = ''
    runHook preInstall
    cp -r dist/ $out
    runHook postInstall
  '';

  meta = {
    description = "Grayjay frontend subpackage";
    inherit (grayjay.meta)
      homepage
      license
      maintainers
      platforms
      ;
  };
}
