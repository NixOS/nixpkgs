{
  buildNpmPackage,
  nodejs_22,

  pname,
  version,
  src,
  npmDepsHash,
}:

buildNpmPackage {
  inherit version npmDepsHash;
  pname = "${pname}-frontend";

  src = "${src}/frontend";

  nodejs = nodejs_22;

  npmBuildScript = "build";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/musivault
    cp -r dist/* $out/share/musivault/

    runHook postInstall
  '';
}
