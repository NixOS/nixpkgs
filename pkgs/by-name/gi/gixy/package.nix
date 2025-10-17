{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  python3,
  nginx,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      pyparsing = super.pyparsing.overridePythonAttrs rec {
        version = "2.4.7";
        src = fetchFromGitHub {
          owner = "pyparsing";
          repo = "pyparsing";
          rev = "pyparsing_${version}";
          sha256 = "14pfy80q2flgzjcx8jkracvnxxnr59kjzp3kdm5nh232gk1v6g6h";
        };
        nativeBuildInputs = [ super.setuptools ];
      };
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "gixy";
  version = "0.1.21";
  pyproject = true;

  # fetching from GitHub because the PyPi source is missing the tests
  src = fetchFromGitHub {
    owner = "yandex";
    repo = "gixy";
    rev = "v${version}";
    sha256 = "sha256-Ak2UTP0gDKoac/rR2h1XCUKld1b41O466ogZNQ1yQN0=";
  };

  patches = [
    # Migrate tests to pytest
    # https://github.com/yandex/gixy/pull/146
    (fetchpatch2 {
      url = "https://github.com/yandex/gixy/compare/6f68624a7540ee51316651bda656894dc14c9a3e...b1c6899b3733b619c244368f0121a01be028e8c2.patch";
      hash = "sha256-6VUF2eQ2Haat/yk8I5qIXhHdG9zLQgEXJMLfe25OKEo=";
    })
    ./python3.13-compat.patch
  ];

  build-system = [ python.pkgs.setuptools ];

  dependencies = with python.pkgs; [
    cached-property
    configargparse
    pyparsing
    jinja2
    six
  ];

  nativeCheckInputs = [ python.pkgs.pytestCheckHook ];

  pythonRemoveDeps = [ "argparse" ];

  passthru = {
    inherit (nginx.passthru) tests;
  };

  meta = {
    description = "Nginx configuration static analyzer";
    mainProgram = "gixy";
    longDescription = ''
      Gixy is a tool to analyze Nginx configuration.
      The main goal of Gixy is to prevent security misconfiguration and automate flaw detection.
    '';
    homepage = "https://github.com/yandex/gixy";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mpl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
