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
    hash = "sha256-yq88kbrKn9HMwvxcWNXm7zonAqTs8T2i7iQAsD0TtnU=";
  };
  npmBuildScript = "build";

  dontInstall = true;

  meta = meta // {
    description = "HTML mail templates for LaSuite Meet";
  };
})
