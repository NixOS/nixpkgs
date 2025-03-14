{
  fetchFromGitHub,
  lib,
  kicad,
  python3Packages,
  xvfb-run,
}:

python3Packages.buildPythonApplication rec {
  pname = "interactive-html-bom";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openscopeproject";
    repo = "InteractiveHtmlBom";
    tag = "v${version}";
    hash = "sha256-jUHEI0dWMFPQlXei3+0m1ruHzpG1hcRnxptNOXzXDqQ=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = [
    python3Packages.jsonschema
    python3Packages.wxpython
    python3Packages.kicad
  ];

  nativeCheckInputs = [
    xvfb-run
  ];

  checkPhase = ''
    runHook preCheck

    cp ${kicad.base}/share/kicad/demos/stickhub/StickHub.kicad_pcb .
    HOME=$(mktemp -d) xvfb-run $out/bin/generate_interactive_bom --no-browser StickHub.kicad_pcb

    runHook postCheck
  '';

  meta = {
    description = "Interactive HTML BOM generation for KiCad, EasyEDA, Eagle, Fusion360 and Allegro PCB designer";
    homepage = "https://github.com/openscopeproject/InteractiveHtmlBom/";
    license = lib.licenses.mit;
    changelog = "https://github.com/openscopeproject/InteractiveHtmlBom/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ wuyoli ];
    mainProgram = "generate_interactive_bom";
  };
}
