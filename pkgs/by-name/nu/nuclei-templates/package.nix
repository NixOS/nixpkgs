{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nuclei-templates";
  version = "9.8.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "nuclei-templates";
    rev = "refs/tags/v${version}";
    hash = "sha256-BdlS0gBeGI+5hEgUvkdJPEuZhXpA7Spd2wJ2PtmCkpM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nuclei-templates
    cp -R cloud code dast dns file headless helpers http javascript network profiles ssl \
      $out/share/nuclei-templates/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Templates for the nuclei engine to find security vulnerabilities";
    homepage = "https://github.com/projectdiscovery/nuclei-templates";
    changelog = "https://github.com/projectdiscovery/nuclei-templates/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
}
