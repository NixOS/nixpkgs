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
  pname = "${pname}-backend";

  src = "${src}/backend";

  nodejs = nodejs_22;

  # The upstream lockfile is missing `resolved` and `integrity` fields for many
  # packages (a known npm bug, see https://github.com/npm/cli/issues/6301).
  # Use a regenerated lockfile with all fields populated.
  postPatch = ''
    cp ${./backend-package-lock.json} package-lock.json
  '';

  npmBuildScript = "build";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r dist package.json $out/opt/
    cp -r node_modules $out/opt/

    runHook postInstall
  '';
}
