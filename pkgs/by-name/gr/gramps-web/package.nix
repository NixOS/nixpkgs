{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "gramps-web";
  version = "26.9.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps-web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ej2uTYfdw0as31Xg5yXwpHl8OVJAzVFnTTnA/q3I4Nk=";
  };

  npmDepsHash = "sha256-Wm4+0GihvvcBXs1oaaBzmKrS5/sqCUeoBrU9LlUDMgU=";

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  meta = {
    description = "Open source online genealogy system, the frontend of Gramps Web";
    homepage = "https://www.grampsweb.org/";
    changelog = "https://github.com/gramps-project/gramps-web/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      anthonyroussel
      jk
    ];
  };
})
