{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "skypilot";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "skypilot-org";
    repo = "skypilot";
    tag = "v${version}";
    hash = "sha256-Vs6vOrJLYexezd7qAnSGvheS8/atoNl5l/+q0nWdMpY=";
  };

  pyproject = true;

  build-system = with python3Packages; [ setuptools ];

  # when updating, please ensure package version constraints stipulaed
  # in setup.py are met
  propagatedBuildInputs = with python3Packages; [
    cachetools
    click
    colorama
    cryptography
    filelock
    jinja2
    jsonschema
    networkx
    packaging
    pandas
    pendulum
    prettytable
    psutil
    python-dotenv
    pyyaml
    pulp
    requests
    rich
    tabulate
    typing-extensions
    wheel
  ];

  meta = {
    description = "Run LLMs and AI on any Cloud";
    longDescription = ''
      SkyPilot is a framework for running LLMs, AI, and batch jobs on any
      cloud, offering maximum cost savings, highest GPU availability, and
      managed execution.
    '';
    homepage = "https://github.com/skypilot-org/skypilot";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ seanrmurphy ];
    mainProgram = "sky";
  };
}
