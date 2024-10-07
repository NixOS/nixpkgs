{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nuclei-templates";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "nuclei-templates";
    rev = "refs/tags/v${version}";
    hash = "sha256-unQ/c3S1uJGSE7DoDsKnnI0n7YGe7s8F0g+yUNB4xH4=";
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
