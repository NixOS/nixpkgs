{
  lib,
  fetchFromGitHub,
  python3Packages,
  ripgrep,
  gitMinimal,
}:

python3Packages.buildPythonApplication rec {
  pname = "seagoat";
  version = "0.50.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kantord";
    repo = "SeaGOAT";
    tag = "v${version}";
    hash = "sha256-tf3elcKXUwBqtSStDksOaSN3Q66d72urrG/Vab2M4f0=";
  };

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    appdirs
    blessed
    chardet
    flask
    deepmerge
    chromadb
    gitpython
    jsonschema
    pygments
    requests
    nest-asyncio
    waitress
    psutil
    stop-words
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    freezegun
    pytest-asyncio
    pytest-mock
    pytest-snapshot
    gitMinimal
    ripgrep
  ];

  disabledTests = import ./failing_tests.nix;

  # require network access
  disabledTestPaths = [
    "tests/test_chroma.py"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    git init
  '';

  postInstall = ''
    wrapProgram $out/bin/seagoat-server \
      --prefix PATH : "${ripgrep}/bin"
  '';

  meta = {
    description = "Local-first semantic code search engine";
    homepage = "https://kantord.github.io/SeaGOAT/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lavafroth ];
    mainProgram = "seagoat";
  };
}
