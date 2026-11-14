{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "gramps-web";
  version = "26.11.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps-web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vm5qpcS87RGmosDM+/4UogNJ8Zjhae6SqZWbENMhRiI=";
  };

  npmDepsHash = "sha256-XAFgQMQUXXa8lKM0GSIMiBcVSdNGzCfs2rslk/UuB+M=";

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
