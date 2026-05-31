{
  lib,
  python3Packages,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "nipap-www";
  inherit (python3Packages.nipap) version src;
  pyproject = true;

  sourceRoot = "${src.name}/nipap-www";

  postPatch = ''
    # Load Flask config additionally from FLASK_ environment variables.
    # This makes providing secrets easier.
    sed -i nipapwww/__init__.py \
      -e '/^\s*app =/a\    app.config.from_prefixed_env()'
  '';

  pythonRelaxDeps = true; # deps are tightly specified

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    flask
    nipap
    pynipap
  ];

  passthru = {
    inherit (python3Packages) gunicorn python;
    pythonPath = python3Packages.makePythonPath dependencies;
    tests.nixos = nixosTests.nipap;
  };

  meta = {
    description = "Neat IP Address Planner CLI, web UI";
    longDescription = ''
      NIPAP is the best open source IPAM in the known universe,
      challenging classical IP address management (IPAM) systems in many areas.
    '';
    homepage = "https://github.com/SpriteLink/NIPAP";
    changelog = "https://github.com/SpriteLink/NIPAP/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lukegb
    ];
    platforms = lib.platforms.all;
  };
}
