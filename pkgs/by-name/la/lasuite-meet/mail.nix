{
  src,
  version,
  meta,
  fetchNpmDeps,
  buildNpmPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "lasuite-meet-mail";
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/src/mail";

  # TODO: Remove package-lock.json patch when
  # https://github.com/suitenumerique/meet/pull/1321 is merged.
  postPatch = ''
    substituteInPlace bin/html-to-plain-text bin/mjml-to-html \
      --replace-fail \
        '../backend/core/templates/mail' \
        '${placeholder "out"}'

    cp ${./package-lock.json} package-lock.json
  '';

  npmDeps = fetchNpmDeps {
    pname = "${finalAttrs.pname}-npm-deps";
    inherit version src;
    inherit (finalAttrs) sourceRoot;
    hash = "sha256-jjLzgGqCsMu6Smyfaam6coqOM9UW2zG88adSPVrWPEE=";

    postPatch = "cp ${./package-lock.json} package-lock.json";
  };
  npmBuildScript = "build";

  dontInstall = true;

  meta = meta // {
    description = "HTML mail templates for LaSuite Meet";
  };
})
