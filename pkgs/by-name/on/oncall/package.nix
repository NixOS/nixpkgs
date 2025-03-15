{
  lib,
  python310,
  fetchFromGitHub,

  # Override Python packages using
  # self: super: { pkg = super.pkg.overridePythonAttrs (oldAttrs: { ... }); }
  # Applied after defaultOverrides
  packageOverrides ? self: super: { },
}:
let
  defaultOverrides = [
    # Override the version of some packages pinned in Oncall's setup.py
    (self: super: {
      # Support for Falcon 4.X missing
      # https://github.com/linkedin/oncall/issues/430
      falcon = super.falcon.overridePythonAttrs (oldAttrs: rec {
        version = "3.1.3";
        src = fetchFromGitHub {
          owner = "falconry";
          repo = "falcon";
          tag = version;
          hash = "sha256-7719gOM8WQVjODwOSo7HpH3HMFFeCGQQYBKktBAevig=";
        };
        doCheck = false;
      });
      gunicorn = super.gunicorn.overridePythonAttrs (oldAttrs: rec {
        version = "20.1.0";
        src = fetchFromGitHub {
          owner = "benoitc";
          repo = "gunicorn";
          tag = version;
          hash = "sha256-xdNHm8NQWlAlflxof4cz37EoM74xbWrNaf6jlwwzHv4=";
        };
        doCheck = false;
        dependencies = (oldAttrs.dependencies or [ ]) ++ [
          self.setuptools
        ];
      });
      gevent = super.gevent.overridePythonAttrs (oldAttrs: rec {
        version = "22.10.2";
        src = self.fetchPypi {
          inherit version;
          pname = "gevent";
          hash = "sha256-HKAdoXbuN7NSeicC99QNvJ/7jPx75aA7+k+e7EXlXEY=";
        };
      });
    })
  ];

  python = python310.override {
    self = python;
    packageOverrides = lib.composeManyExtensions (defaultOverrides ++ [ packageOverrides ]);
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "oncall";
  version = "2.1.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "linkedin";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-oqzU4UTpmAcZhqRilquxWQVyHv8bqq0AGraiSqwauiI=";
  };

  dependencies = with python.pkgs; [
    beaker
    falcon
    falcon-cors
    gevent
    gunicorn
    icalendar
    irisclient
    jinja2
    pymysql
    pytz
    pyyaml
    ujson
    webassets
  ];

  pythonImportsCheck = [
    "oncall"
  ];

  meta = {
    description = "A calendar web-app designed for scheduling and managing on-call shifts";
    homepage = "http://oncall.tools";
    changelog = "https://github.com/linkedin/oncall/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "oncall";
  };
}
