{
  fetchFromGitHub,
  lib,
  kicad,
  python3Packages,
  xvfb-run,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "interactive-html-bom-inti-cmnb";
  version = "2.11.0-1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "INTI-CMNB";
    repo = "InteractiveHtmlBom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1yjYkNSAuYt1H030Wg9mbmOLuufxzjgshhhWkptbomw=";
  };

  build-system = with python3Packages; [ setuptools ];

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

    ln -s ${kicad.base}/share/kicad/demos/stickhub/StickHub.kicad_pcb .
    HOME=$(mktemp -d) xvfb-run $out/bin/generate_interactive_bom.py --no-browser StickHub.kicad_pcb

    runHook postCheck
  '';

  buildPhase = ''
    python setup.py build
  '';

  installPhase = ''
    python setup.py install --prefix=$out
  '';

  postInstall = ''
    mv $out/bin/generate_interactive_bom $out/bin/generate_interactive_bom.py
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Interactive HTML BOM generation for KiCad, EasyEDA, Eagle, Fusion360 and Allegro PCB designer";
    homepage = "https://github.com/INTI-CMNB/InteractiveHtmlBom";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scd31 ];
    mainProgram = "generate_interactive_bom.py";
  };
})
