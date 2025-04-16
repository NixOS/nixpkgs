{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "piston-cli";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Shivansh-007";
    repo = "piston-cli";
    tag = "v${version}";
    hash = "sha256-5S+1YGoPMprWnlsTGGPHtlQT974TsFgct3jVPngTT1k=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = with python3Packages; [
    appdirs
    click
    coloredlogs
    more-itertools
    prompt-toolkit
    rich
    requests-cache
    pygments
    pyyaml
    more-itertools
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'piston = "piston:main"' 'piston = "piston.cli:cli_app"'
  '';

  pythonRelaxDeps = [
    "rich"
    "more-itertools"
    "PyYAML"
    "requests-cache"
  ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  versionCheckProgram = "${placeholder "out"}/bin/piston";

  pythonImportsCheck = [ "piston" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Piston api tool";
    homepage = "https://github.com/Shivansh-007/piston-cli";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "piston";
  };
}
