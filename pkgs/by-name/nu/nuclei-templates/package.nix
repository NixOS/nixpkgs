{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nuclei-templates";
  version = "10.2.4";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "nuclei-templates";
    tag = "v${version}";
    hash = "sha256-RBZjtKkUk+kOob2VBFh1rPrVuUsIBMAetUhMClOZY6s=";
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
    changelog = "https://github.com/projectdiscovery/nuclei-templates/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.all;
  };
}
