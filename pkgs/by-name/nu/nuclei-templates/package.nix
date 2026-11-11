{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nuclei-templates";
  version = "10.5.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "nuclei-templates";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A7yY6FCorZq3NzqoyQv+5p8ZKrg3WEoHwKRF2+cWngY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nuclei-templates
    cp -R cloud code dast dns file headless helpers http javascript network profiles ssl \
      $out/share/nuclei-templates/

    runHook postInstall
  '';

  meta = {
    description = "Templates for the nuclei engine to find security vulnerabilities";
    homepage = "https://github.com/projectdiscovery/nuclei-templates";
    changelog = "https://github.com/projectdiscovery/nuclei-templates/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.all;
  };
})
