{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "gramps-web";
  version = "26.10.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps-web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BmORfDEFusTPkzRot5MhH/WjQ9SWSa3XQrmKckpNcvw=";
  };

  npmDepsHash = "sha256-zRtyJTskfkv0Epk4A/dJmZmCGGepX6sEUD/48GZuyRs=";

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  meta = {
    description = "Open source online genealogy system, the frontend of Gramps Web";
    homepage = "https://www.grampsweb.org/";
    changelog = "https://github.com/gramps-project/gramps-web/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      anthonyroussel
      jk
    ];
  };
})
