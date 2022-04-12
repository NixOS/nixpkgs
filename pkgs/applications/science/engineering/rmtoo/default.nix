{ lib
, python3
, fetchFromGitHub
, substituteAll
, git
, graphviz
, texlive
, gnuplot
}:

let
  python3Override = python3.override {
    packageOverrides = self: super: {
      gitdb = super.gitdb.overridePythonAttrs (oldAttrs: rec {
        inherit (oldAttrs) pname;
        version = "0.6.4";
        disabled = "";
        src = python3.pkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-o+u8J74DWi6HTtkE31FuNfSimneKdkOF3gneng8Tllg=";
        };
        postPatch = '''';
      });

      GitPython102 = super.GitPython.overridePythonAttrs (oldAttrs: rec {
        inherit (oldAttrs) pname;
        version = "1.0.2";
        disabled = "";
        src = fetchFromGitHub {
          owner = "gitpython-developers";
          repo = pname;
          rev = version;
          sha256 = "sha256-5IdI6yy3AtsrUkZWohcca7bJIWhMGpi/Go5EoK/4l54=";
        };
        patches = [ ];
        postPatch = ''
          substituteInPlace ./git/cmd.py --replace "\"git\""  "${git}/bin/git"
          grep git ./git/cmd.py
        '';
      });

      GitPython306 = super.GitPython.overridePythonAttrs (oldAttrs: rec {
        inherit (oldAttrs) pname;
        version = "3.0.6";
        src = fetchFromGitHub {
          owner = "gitpython-developers";
          repo = pname;
          rev = version;
          sha256 = "sha256-tb+7UT3mxVzPxJpbIgylylUs4bpEeme55YDfzlUz4QY=";
        };
      });

      odfpy134 = super.odfpy.overridePythonAttrs (oldAttrs: rec {
        inherit (oldAttrs) pname;
        version = "1.3.4";
        src = python3.pkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-E+bXrs60nj29idoA1wD84+PwcXzQ2xu2+xbFTlebUfg=";
        };
        doCheck = false;
        checkInputs = [ ];
        checkPhase = ''
          pushd tests
          rm runtests
          for file in test*.py; do
            python  $file
          done
        '';
      });
    };
  };
in python3.pkgs.buildPythonApplication rec {
  pname = "rmtoo";
  version = "unstable-2021-11-09";
  pythonVersion = "3.8";

  src = fetchFromGitHub {
    owner = "florath";
    repo = pname;
    rev = "6ffe08703451358dca24b232ee4380b1da23bcad";
    sha256 = "sha256-0VpnfU/0gmEXnNVEUuZgj915glFX8OzPQ/4bW1G81go=";
  };

  buildInputs = [
    graphviz
    texlive.combined.scheme-basic
  ];

  propagatedBuildInputs = [
    python3
  ] ++ (with python3.pkgs; [
    GitPython
    flake8
    future
    gitdb
    jinja2
    numpy
    odfpy
    pylint
    pyyaml
    scipy
    six
    stevedore
  ]);

  postPatch = ''
    substituteInPlace ./requirements.txt \
      --replace "==" ">=" \
      --replace "~" ">="
    substituteInPlace ./setup.py --replace "==" ">="
  '';

  doCheck = true;

  checkInputs = with python3.pkgs; [
    pytestCheckHook
    tox
  ];

  pythonImportsCheck = [ "rmtoo" ];

  pytestFlagsArray = [ "rmtoo/tests/" ];

  meta = with lib; {
    description = "Requirements management tool";
    homepage = "https://github.com/florath/rmtoo";
    changelog = "https://github.com/florath/rmtoo/releases";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yuu ];
    platforms = platforms.all;
  };
}
