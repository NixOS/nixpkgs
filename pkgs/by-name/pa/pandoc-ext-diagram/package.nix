{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "pandoc-ext-diagram";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "pandoc-ext";
    repo = "diagram";
    tag = "v1.2.0";
    hash = "sha256-NuHru6uYewuFksWGlWkvQRc6NDC5S4mnnmJlDQbVF+c=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D ./_extensions/diagram/*.lua -t $out

    runHook postInstall
  '';

  meta = {
    description = "Generate diagrams from embedded code; supports Mermaid, Dot/GraphViz, PlantUML, Asymptote, D2, CeTZ, and TikZ";
    homepage = "https://github.com/pandoc-ext/diagram";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
}
