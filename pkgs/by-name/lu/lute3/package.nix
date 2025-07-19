{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
  japaneseSupport ? true,
  mecab,
}:
let
  version = "3.10.1";
  python = python3.override {
    packageOverrides = after: before: {
      platformdirs = before.platformdirs.overridePythonAttrs (
        oldAttrs:
        let
          version = "3.11.0";
        in
        {
          inherit version;
          src = fetchFromGitHub {
            owner = "platformdirs";
            repo = "platformdirs";
            tag = version;
            hash = "sha256-E3qwAczUzJOYO4IDul9uO6K6wowOtYpQ7Q76TA+lIho=";
          };
        }
      );

      waitress = before.waitress.overridePythonAttrs (
        oldAttrs:
        let
          version = "2.1.2";
        in
        {
          inherit version;
          src = fetchPypi {
            inherit version;
            pname = "waitress";
            hash = "sha256-eApAgsX7wP3movz+Xibm78Ho9CVzCGPAQIV2l4H1Hro=";
          };
        }
      );
    };
  };
  python3Packages = python.pkgs;
  src =
    (fetchFromGitHub {
      owner = "LuteOrg";
      repo = "lute-v3";
      tag = version;
      hash = "sha256-ZeMXFky/MBW/nce+aUDYerh/9LHBDjl/Eh4f/4obXs8=";
      fetchSubmodules = true;
    }).overrideAttrs
      # https://github.com/NixOS/nixpkgs/issues/195117#issuecomment-1410398050
      {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      };
in
python3Packages.buildPythonApplication {
  inherit src version;
  pname = "lute3";
  pyproject = true;

  build-system = [ python3Packages.flit-core ];

  dependencies = [
    python3Packages.flask-sqlalchemy
    python3Packages.flask-wtf
    python3Packages.natto-py
    python3Packages.jaconv
    python3Packages.platformdirs
    python3Packages.beautifulsoup4
    python3Packages.toml
    python3Packages.waitress
    python3Packages.openepub
    python3Packages.pyparsing
    python3Packages.pypdf
    python3Packages.subtitle-parser
    python3Packages.ahocorapy
    python3Packages.requests
    python3Packages.pyyaml
  ];

  makeWrapperArgs =
    let
      packagesToBinPath = lib.optionals japaneseSupport [ mecab ];
    in
    [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath packagesToBinPath)
    ];

  propagatedBuildInputs = lib.optionals japaneseSupport [ mecab ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    mecab
  ];

  preCheck = ''
    echo "ENV: prod
    DBNAME: test_lute.db
    DATAPATH: $(mktemp -d)" > lute/config/config.yml;
    export MECAB_PATH="${mecab}/lib/libmecab.so";
  '';

  disabledTestPaths = [
    "tests/features/test_rendering.py"
    "tests/features/test_term_import.py"
  ];

  meta = {
    homepage = "https://github.com/LuteOrg/lute-v3";
    description = "LUTE = Learning Using Texts: learn languages through reading.";
    longDescription = ''
      LUTE (Learning Using Texts) is a standalone web application that you install on your computer and read texts with.

      Lute contains the core features you need for learning through reading:

      * defining languages and dictionaries
      * creating and editing texts
      * creating terms and multi-word terms
    '';
    changelog = "https://raw.githubusercontent.com/LuteOrg/lute-v3/refs/tags/${version}/docs/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "lute";
  };
}
