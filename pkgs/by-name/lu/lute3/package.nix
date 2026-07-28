{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lute3";
  version = "3.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LuteOrg";
    repo = "lute-v3";
    tag = finalAttrs.version;
    hash = "sha256-ZeMXFky/MBW/nce+aUDYerh/9LHBDjl/Eh4f/4obXs8=";
    fetchSubmodules = true;
    # The submodule is registered with an SSH URL, which the fetcher cannot
    # resolve inside the sandbox. Rewrite it to HTTPS.
    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
  };

  build-system = with python3Packages; [ flit-core ];

  # Upstream caps platformdirs at <4 and waitress at <3, but it only calls
  # PlatformDirs() and waitress.serve(), neither of which changed in those
  # major releases.
  pythonRelaxDeps = [
    "platformdirs"
    "waitress"
  ];

  dependencies = with python3Packages; [
    ahocorapy
    beautifulsoup4
    flask-sqlalchemy
    flask-wtf
    jaconv
    natto-py
    openepub
    platformdirs
    pyparsing
    pypdf
    pyyaml
    requests
    subtitle-parser
    toml
    waitress
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-bdd
    pytestCheckHook
  ];

  preCheck = ''
    echo "ENV: prod
    DBNAME: test_lute.db
    DATAPATH: $(mktemp -d)" > lute/config/config.yml;
  '';

  meta = {
    homepage = "https://github.com/LuteOrg/lute-v3";
    description = "Learn languages through reading";
    longDescription = ''
      LUTE (Learning Using Texts) is a standalone web application that you install on your computer and read texts with.

      Lute contains the core features you need for learning through reading:

      * defining languages and dictionaries
      * creating and editing texts
      * creating terms and multi-word terms
    '';
    changelog = "https://raw.githubusercontent.com/LuteOrg/lute-v3/${finalAttrs.src.tag}/docs/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.imalison ];
    mainProgram = "lute";
  };
})
