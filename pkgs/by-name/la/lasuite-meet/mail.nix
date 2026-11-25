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

  postPatch = ''
    substituteInPlace bin/html-to-plain-text bin/mjml-to-html \
      --replace-fail \
        '../backend/core/templates/mail' \
        '${placeholder "out"}'
  '';

  npmDeps = fetchNpmDeps {
    pname = "${finalAttrs.pname}-npm-deps";
    inherit version src;
    inherit (finalAttrs) sourceRoot;
    hash = "sha256-9nA5+QX27X2LCHO4VWiZ9r1I44IEw9ZP5yE4/NZOEyQ=";
  };
  npmBuildScript = "build";

  dontInstall = true;

  meta = meta // {
    description = "HTML mail templates for LaSuite Meet";
  };
})
